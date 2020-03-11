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
    
    QJsonObject params;
    params.insert(QStringLiteral("PaymentID"), pid);
    QJsonObject data = buildMessage(QStringLiteral("GetSaleStatus"), params);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftPOSAPIv3::receiveSaleStatusResponse);
}

void GraftPOSAPIv3::presale()
{
    mRetries = 0;
    mRequest.setUrl(nextAddress(QStringLiteral("presale")));
    crypto::public_key pub_key;
    crypto::generate_keys(pub_key, m_secret_key);
    QString paymentId = generate_payment_id(pub_key);
    QJsonObject params;
    params.insert("PaymentID", paymentId);
    QByteArray data = QJsonDocument(params).toJson();
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
    
    

//            request::PaymentInfo payment_info;
//            payment_info.Amount = amount;
//            std::string encryptedPurchaseDetails;
//            graft::crypto_tools::encryptMessage(SALE_ITEMS, wallet_pub_key_vector, encryptedPurchaseDetails);
//            payment_info.Details = epee::string_tools::buff_to_hex_nodelimer(encryptedPurchaseDetails);
//            // encrypt whole container with auth_sample keys + wallet key;
//            // TODO: by the specs it should be only encrypted with auth sample keys, auth sample should return
//            // plain-text amount and encrypted payment details; for simplicity we just add wallet key to the one-to-many scheme
//            std::string encrypted_payment_blob;
//            auth_sample_pubkeys.push_back(wallet_pub_key);
//            graft::crypto_tools::encryptMessage(graft::to_json_str(payment_info), auth_sample_pubkeys, encrypted_payment_blob);
    
//            // 3.3. Set pos proxy addess and wallet in sale request
//            sale_req.paymentData.PosProxy = m_presale_resp.PosProxy;
//            sale_req.paymentData.EncryptedPayment = epee::string_tools::buff_to_hex_nodelimer(encrypted_payment_blob);
//            sale_req.PaymentID = m_payment_id;
    
//            // 3.4. call "/sale"
//            std::string dummy;
//            int http_status = 0;
//            ErrorResponse err_resp;
    
//            bool r = invoke_http_rest("/dapi/v2.0/sale", sale_req, dummy, err_resp, m_http_client, http_status, m_network_timeout, "POST");
//            if (!r) {
//                MERROR("Failed to invoke sale: " << graft::to_json_str(err_resp));
//            }
    
    
    
//    mLastRequest = array;
//    QNetworkReply *reply = mManager->post(mRequest, array);
//    connect(reply, &QNetworkReply::finished, this, &GraftPOSAPIv3::receiveSaleResponse);
}

void GraftPOSAPIv3::receivePresaleResponse()
{
    mLastError.clear();
    qDebug() << "presale Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    
    QJsonObject object;
    int httpStatusCode = 0;
    
    if (processReplyRest(reply, httpStatusCode, object)) {
        if (httpStatusCode == 200) {
            m_presaleResponse.fromJson(object);
            emit presaleResponseReceived(true);
        } else if (httpStatusCode == 500) {
            mLastError = object.value("message").toString();
            emit presaleResponseReceived(false);
        }
    }
    else // network error, retry;
    {
        QNetworkReply *reply = retry();
        if (reply)
        {
            connect(reply, &QNetworkReply::finished, this, &GraftPOSAPIv3::receivePresaleResponse);
        }
    }
}

void GraftPOSAPIv3::receiveSaleResponse()
{
    mLastError.clear();
    qDebug() << "Sale Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    
    QJsonObject object;
    int httpStatusCode = 0;
    
    if (processReplyRest(reply, httpStatusCode, object)) {
        emit 
    }
    
    
    if (!object.isEmpty())
    {
        emit saleResponseReceived(object.value(QLatin1String("Result")).toInt(),
                                  object.value(QLatin1String("PaymentID")).toString(),
                                  object.value(QLatin1String("BlockNum")).toInt());
    }
    else
    {
        QNetworkReply *reply = retry();
        if (reply)
        {
            connect(reply, &QNetworkReply::finished, this, &GraftPOSAPIv3::receiveSaleResponse);
        }
    }
}

void GraftPOSAPIv3::receiveRejectSaleResponse()
{
    mLastError.clear();
    qDebug() << "RejectSale Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        emit rejectSaleResponseReceived(object.value(QLatin1String("Result")).toInt());
    }
    else
    {
        QNetworkReply *reply = retry();
        if (reply)
        {
            connect(reply, &QNetworkReply::finished,
                    this, &GraftPOSAPIv3::receiveRejectSaleResponse);
        }
    }
}

void GraftPOSAPIv3::receiveSaleStatusResponse()
{
    // TODO;
}

GraftPOSAPIv3::PresaleResponse GraftPOSAPIv3::PresaleResponse::fromJson(const QJsonObject &arg)
{
    PresaleResponse result;
    result.BlockNumber = arg.value("BlockNumber").toVariant().toULongLong();
    result.BlockHash   = arg.value("BlockHash").toString();
    for (const auto item: arg.value("AuthSample").toArray()) {
        result.AuthSample.push_back(item.toString());
    }
    result.NodeAddress = GraftGenericAPIv3::NodeAddress::fromJson(arg.value("NodeAddress").toObject());
    return result;
}
