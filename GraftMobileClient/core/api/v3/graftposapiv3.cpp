#include "graftposapiv3.h"

#include "crypto/crypto.h"
#include "epee/string_tools.h"
#include "utils/cryptmsg.h"
#include "utils/rta_helpers_gui.h"

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
    
    uint64_t get_nett_amount(uint64_t gross_amount)
    {
        return gross_amount - (gross_amount / 1000 * 5); // 0.5% total
    }
    
}

GraftPOSAPIv3::GraftPOSAPIv3(const QStringList &addresses, GraftGenericAPIv3::NetType nettype, const QString &dapiVersion,
                             QObject *parent)
    : GraftGenericAPIv3(addresses, dapiVersion, parent), m_nettype(nettype)
{

}

void GraftPOSAPIv3::sale(const QString &address, double amount,
                       const QString &saleDetails)
{
    m_amount = amount;
    m_address = address;
    m_saleDetails = saleDetails;
    m_txBlob.clear();
    presale();
}

void GraftPOSAPIv3::rejectSale(const QString &pid)
{
    if (m_txBlob.empty()) {
        // wallet didn't sent tx yet and we don't know Wallet Proxy public key yet;
        // options: 
        //   1. just stop polling for get_payment_status and return to main screen
        //   2. make "Cancel" disabled until wallet processes payment but still have a timeout?
        //   3. anything else?
        // TODO: cancel "get_payment_status" polling
        emit GraftGenericAPIv3::saleStatusResponseReceived(OperationStatus::FailRejectedByPOS);
        return;
    }
    
    EncryptedPaymentStatus req;
    PaymentStatus paymentStatus;
    paymentStatus.Status = static_cast<int>(FailRejectedByPOS);
    paymentStatus.PaymentID = pid;
    paymentStatus.sign(m_public_key, m_secret_key);
    QStringList memberKeys;
    std::vector<std::string> tmp_keys;
    if (!graft::rta_helpers::gui::get_rta_keys_from_tx(m_txBlob, tmp_keys)) {
        mLastError = "Failed to extract rta keys from tx";
        emit error(mLastError);
        return;
    }
            
    for (const auto &tmp_key: tmp_keys) 
        memberKeys.append(QString::fromStdString(tmp_key));

    qDebug() << "about to send reject for payment: " << pid;

    req.PaymentID = pid;
    std::vector<crypto::public_key> keys;
    deserializeKeys(memberKeys, keys);
    req.encrypt(paymentStatus, keys);
    
    mRequest.setUrl(nextAddress(QStringLiteral("pos_reject_payment")));
    mRetries = 0;
    QByteArray data = QJsonDocument(req.toJson()).toJson();
    mLastRequest = data;
    mTimer.start();
    QNetworkReply * reply = mManager->post(mRequest, data);
    connect(reply, &QNetworkReply::finished, this, &GraftPOSAPIv3::receiveRejectSaleResponse);
}


void GraftPOSAPIv3::approveSale(const QString &pid)
{
    Q_UNUSED(pid)
    std::string encrypted_tx_hex;
    if (!graft::rta_helpers::gui::pos_approve_tx(m_txBlob, m_public_key, m_secret_key, 8, encrypted_tx_hex)) {
        mLastError = QString("Failed to approve tx for payment '%1'").arg(pid);
        qCritical() << mLastError;
        emit error(mLastError);
        return;
    }
    mRequest.setUrl(nextAddress(QStringLiteral("approve_payment")));
    QJsonObject params;
    params.insert("TxBlob", QString::fromStdString(encrypted_tx_hex));
    QByteArray data = QJsonDocument(params).toJson();
    mLastRequest = data;
    mTimer.start();
    QNetworkReply * reply = mManager->post(mRequest, data);
    connect(reply, &QNetworkReply::finished, this, &GraftPOSAPIv3::receiveApproveSale);
}

void GraftPOSAPIv3::getRtaTx(const QString &pid)
{
    mRetries = 0;
    crypto::signature sign;
    crypto::hash hash;
    std::string _pid = pid.toStdString();
    crypto::cn_fast_hash(_pid.data(), _pid.size(), hash);
    crypto::generate_signature(hash, m_public_key, m_secret_key, sign);
    mRequest.setUrl(nextAddress(QStringLiteral("get_tx")));
    QJsonObject params;
    params.insert("PaymentID", pid);
    params.insert("Signature", QString::fromStdString(epee::string_tools::pod_to_hex(sign)));
    QByteArray data = QJsonDocument(params).toJson();
    mLastRequest = data;
    mTimer.start();
    QNetworkReply * reply = mManager->post(mRequest, data);
    connect(reply, &QNetworkReply::finished, this, &GraftPOSAPIv3::receiveGetRtaTxResponse);
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
    paymentInfo.insert("Amount", QJsonValue::fromVariant((quint64)toAtomic(m_amount)));
    std::string encryptedPurchaseDetails;
    
    graft::crypto_tools::encryptMessage(m_saleDetails.toStdString(), wallet_pub_key_vector, encryptedPurchaseDetails);
    paymentInfo.insert("Details",  QString::fromStdString(epee::string_tools::buff_to_hex_nodelimer(encryptedPurchaseDetails)));
    
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
    mLastError.clear();
    qDebug() << "/pos_reject_sale Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    
    int httpStatusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    // expected response is 202 status code, no payload
    if (httpStatusCode == 202) {
        emit rejectSaleResponseReceived(0);
    } else {
        emit rejectSaleResponseReceived(1);
    }
}

void GraftPOSAPIv3::receiveGetRtaTxResponse()
{
    mLastError.clear();
    qDebug() << "/get_tx Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    
    QJsonObject object;
    int httpStatusCode = 0;
    
    if (processReplyRest(reply, httpStatusCode, object)) {
        // 1. decrypt tx, tx_key and tx amount;
        uint64_t amount = 0;
        if (!graft::rta_helpers::gui::decrypt_tx_and_amount(m_address.toStdString(), static_cast<int>(m_nettype), 
                                                              m_secret_key,
                                                              object.value("TxKeyBlob").toString().toStdString(),
                                                              object.value("TxBlob").toString().toStdString(),
                                                              amount, 
                                                              m_txBlob)) {
            mLastError = QString("failed to decrypt amount from tx for payment %1").arg(m_paymentId);
            qCritical() << mLastError;
            emit error(mLastError);
            return;
        }
        // 2. validate amount
        quint64 expected_amount = get_nett_amount(static_cast<quint64>(toAtomic(m_amount)));
        if (expected_amount != amount) {
            mLastError = QString("Wrong sale amount: expected: %1 got %2").arg(toCoins(expected_amount))
                    .arg(toCoins(amount));
            qCritical() << mLastError;
        }
        // 3. signal to upper layer so amount valid/invalid
        emit rtaTxValidated(expected_amount == amount);
        // TODO 4. fix 'responsibility' issue - it's wrong for and API class to have a knowledge about keys/amounts
    } else {
        emit error(mLastError);
    }
}

void GraftPOSAPIv3::receiveApproveSale()
{
    mLastError.clear();
    qDebug() << "/approve_payment Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    
    int httpStatusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    // expected response is 202 status code, no payload
    if (httpStatusCode == 202) {
        qDebug() << "Rta tx approved by pos, waiting for status";
        // TODO better to signal to the "upper level" so it handles the logic?
        emit saleApproveProcessed(true);
    } else {
        qDebug() << "/approve_payment failed";
        emit saleApproveProcessed(false);
    }
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
