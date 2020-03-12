#include "graftposapiv3.h"

#include "crypto/crypto.h"
#include "epee/string_tools.h"
#include "utils/cryptmsg.h"

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>
#include <QCryptographicHash>
#include <QTimer>

#include <boost/uuid/uuid.hpp>
#include <boost/uuid/uuid_generators.hpp>



namespace {
    QString generate_payment_id(const crypto::public_key &pubkey)
    {
        boost::uuids::basic_random_generator<boost::mt19937> gen;
        const boost::uuids::uuid u = gen();
        QCryptographicHash hash(QCryptographicHash::Sha1);
        hash.addData((const char*)u.begin(), u.size());
        hash.addData((const char*)&pubkey, sizeof (pubkey));
        return QString(hash.result().toHex());
    }
    
    static constexpr int ERROR_INVALID_PAYMENT_ID = -32051;
    
}

GraftPOSAPIv3::GraftPOSAPIv3(const QStringList &addresses, const QString &dapiVersion,
                             QObject *parent)
    : GraftGenericAPIv3(addresses, dapiVersion, parent)
{

}

void GraftPOSAPIv3::sale(const QString &address, double amount,
                       const QString &saleDetails)
{
    m_amount = amount;
    m_address = address;
    m_saleDetails = saleDetails;
    presale();
}

void GraftPOSAPIv3::rejectSale(const QString &pid)
{
    
}

void GraftPOSAPIv3::saleStatus(const QString &pid, int blockNumber)
{
    
    Q_UNUSED(blockNumber)
    
    mRetries = 0;
    mRequest.setUrl(nextAddress(QStringLiteral("get_payment_status")));
    
    QJsonObject params;
    params.insert(QStringLiteral("PaymentID"), pid);
    QByteArray array = QJsonDocument(params).toJson();
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftPOSAPIv3::receiveSaleStatusResponse);
}

QString GraftPOSAPIv3::paymentId() const
{
    return m_paymentId;
}

QString GraftPOSAPIv3::walletEncryptionKey() const
{
    return QString::fromStdString(epee::string_tools::pod_to_hex(m_wallet_secret_key));
}

QString GraftPOSAPIv3::posPubkey() const
{
    return QString::fromStdString(epee::string_tools::pod_to_hex(m_public_key));
}

QString GraftPOSAPIv3::blockHash() const
{
    return m_presaleResponse.BlockHash;
}

int GraftPOSAPIv3::blockHeight() const
{
    return m_presaleResponse.BlockNumber;
}

void GraftPOSAPIv3::presale()
{
    mRetries = 0;
    mRequest.setUrl(nextAddress(QStringLiteral("presale")));
    
    crypto::generate_keys(m_public_key, m_secret_key);
    m_paymentId = generate_payment_id(m_public_key);
    QJsonObject params;
    params.insert("PaymentID", m_paymentId);
    QByteArray data = QJsonDocument(params).toJson();
    mLastRequest = data;
    mTimer.start();
    QNetworkReply * reply = mManager->post(mRequest, data);
    connect(reply, &QNetworkReply::finished, this, &GraftPOSAPIv3::receivePresaleResponse);
    
}

void GraftPOSAPIv3::sale()
{
    mRetries = 0;
    
    mRequest.setUrl(nextAddress(QStringLiteral("sale")));
    PaymentData paymentData;
    
    std::vector<crypto::public_key> auth_sample_pubkeys;
    for (const auto & key_str : m_presaleResponse.AuthSample) {
        crypto::public_key pkey;
        if (!epee::string_tools::hex_to_pod(key_str.toStdString(), pkey)) {
            qCritical() << "Failed to parse key from: " << key_str;
            emit error(QStringLiteral("Failed to parse auth sample key"));
            return; //
        }
        auth_sample_pubkeys.push_back(pkey);
        NodeId nodeId; nodeId.Id = key_str;
        paymentData.AuthSampleKeys.push_back(nodeId);
    }
    // extra keypair for a wallet, instead of passing session key
    crypto::public_key wallet_pub_key;
    crypto::generate_keys(wallet_pub_key, m_wallet_secret_key);
    std::vector<crypto::public_key> wallet_pub_key_vector {wallet_pub_key};

    // encrypt purchase details only with wallet key    
    QJsonObject paymentInfo;
    paymentInfo.insert("Amount", QJsonValue(m_amount));
    std::string encryptedPurchaseDetails;
    graft::crypto_tools::encryptMessage(m_saleDetails.toStdString(), wallet_pub_key_vector, encryptedPurchaseDetails);
    
    // encrypt whole container with auth_sample keys + wallet key;
    // TODO: by the specs it should be only encrypted with auth sample keys, auth sample should return
    // plain-text amount and encrypted payment details; for simplicity we just add wallet key to the one-to-many scheme
    std::string encrypted_payment_blob;
    auth_sample_pubkeys.push_back(wallet_pub_key);
    graft::crypto_tools::encryptMessage(QJsonDocument(paymentInfo).toJson().toStdString(), auth_sample_pubkeys, encrypted_payment_blob);
    paymentData.EncryptedPayment = QString::fromStdString(epee::string_tools::buff_to_hex_nodelimer(encrypted_payment_blob));
    
    // 3.3. Set pos proxy addess and wallet in sale request
    paymentData.PosProxy = m_presaleResponse.PosProxy;
    
    QJsonObject request;
    request.insert("PaymentID", m_paymentId);
    request.insert("paymentData", paymentData.toJson());
    
    // 3.4. call "/sale"
    QByteArray data = QJsonDocument(request).toJson();
    
    mLastRequest = data;
    QNetworkReply *reply = mManager->post(mRequest, data);
    connect(reply, &QNetworkReply::finished, this, &GraftPOSAPIv3::receiveSaleResponse);
}

void GraftPOSAPIv3::receivePresaleResponse()
{
    mLastError.clear();
    qDebug() << "/presale Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    
    QJsonObject object;
    int httpStatusCode = 0;
    
    if (processReplyRest(reply, httpStatusCode, object)) {
        m_presaleResponse = PresaleResponse::fromJson(object);
        sale();
    } else {
        mLastError = object.value("message").toString();
        emit error(mLastError);
    }
}

void GraftPOSAPIv3::receiveSaleResponse()
{
    mLastError.clear();
    qDebug() << "/sale Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    
    QJsonObject object;
    int httpStatusCode = 0;
    
    if (processReplyRest(reply, httpStatusCode, object)) {
        emit saleResponseReceived(0, m_paymentId, 0);
    } else {
        emit error(mLastError);
    }
}

void GraftPOSAPIv3::receiveRejectSaleResponse()
{
  
}

void GraftPOSAPIv3::receiveSaleStatusResponse()
{
    mLastError.clear();
    qDebug() << "/get_payment_status Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    
    QJsonObject object;
    
    // specific case: in case wallet is not called /pay yet - supernode will respond with "Payment ID is invalid" error
    int httpStatusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    QByteArray rawData = reply->readAll();
    if (!rawData.isEmpty()) {
        object = QJsonDocument::fromJson(rawData).object();
    }
    
    if (reply->error() == QNetworkReply::NoError) {
        emit saleStatusResponseReceived(object.value("Status").toInt());
    } else if (httpStatusCode == 500 && object.value("code").toInt() == ERROR_INVALID_PAYMENT_ID) { // try again
        // just pass GUI "inProgress" status
        // TODO: make sense to introduce some 'intermediate' status e.g. SalePosted ?
        emit saleStatusResponseReceived(static_cast<int>(OperationStatus::InProgress));
    } else {
        mLastError = QString("Failed to call '%1' - '%2'")
                .arg(mRequest.url().toString())
                .arg(reply->errorString());
        emit error(mLastError);
    }
    reply->deleteLater();
    reply = nullptr;
}

GraftPOSAPIv3::PresaleResponse GraftPOSAPIv3::PresaleResponse::fromJson(const QJsonObject &arg)
{
    PresaleResponse result;
    result.BlockNumber = arg.value("BlockNumber").toVariant().toULongLong();
    result.BlockHash   = arg.value("BlockHash").toString();
    for (const auto item: arg.value("AuthSample").toArray()) {
        result.AuthSample.push_back(item.toString());
    }
    result.PosProxy = GraftGenericAPIv3::NodeAddress::fromJson(arg.value("PosProxy").toObject());
    return result;
}
