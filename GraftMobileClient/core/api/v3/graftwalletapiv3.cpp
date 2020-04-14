#include "graftwalletapiv3.h"
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>
#include <QTimer>
#include <QFile>


namespace  {
    static constexpr size_t PAYMENT_DATA_EXPIRE_TIME_MS = 15 * 1000;
    
}

GraftWalletAPIv3::GraftWalletAPIv3(const QStringList &addresses, const QString &dapiVersion, QObject *parent)
    : GraftGenericAPIv3(addresses, dapiVersion, parent)
{
}

void GraftWalletAPIv3::getPaymentData(const QString &pid, const QString &blockHash, quint64 blockHeight)
{
    mLastPID = pid;
    mLastBlockHeight = blockHeight;
    mLastBlockHash  = blockHash;
    mTimer.start();
    
    getPaymentData();
}

void GraftWalletAPIv3::getSupernodeInfo(const QStringList &ids)
{
    mRetries = 0;
    mRequest.setUrl(nextAddress(QStringLiteral("core/get_supernode_info")));
    QJsonObject params;
    params.insert(QStringLiteral("input"), QJsonArray::fromStringList(ids));
    QByteArray array = QJsonDocument(params).toJson(QJsonDocument::Compact);
    qDebug() << "get_supernode_info url: " << mRequest.url();
    qDebug() << "get_supernode_info input: " << array;
    
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftWalletAPIv3::receiveGetSupernodeInfo);
}



void GraftWalletAPIv3::rejectPay(const QString &pid, int blockNum)
{
#if 0
    // there's no way to reject pay from wallet side after tx submitted
    mRetries = 0;
    QJsonObject params;
    params.insert(QStringLiteral("PaymentID"), pid);
    params.insert(QStringLiteral("BlockNum"), blockNum);
    QJsonObject data = buildMessage(QStringLiteral("WalletRejectPay"), params);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftWalletAPIv3::receiveRejectPayResponse);
#endif    
}

void GraftWalletAPIv3::pay(const QString &pid, const QString &address, double amount, int blockNum)
{
    abort();
    mRetries = 0;
    mRequest.setUrl(nextAddress());
    QJsonObject params;
    params.insert(QStringLiteral("Account"), accountPlaceholder());
    params.insert(QStringLiteral("PaymentID"), pid);
    params.insert(QStringLiteral("POSAddress"), address);
    params.insert(QStringLiteral("Amount"), -666);
    params.insert(QStringLiteral("BlockNum"), blockNum);
    QJsonObject data = buildMessage(QStringLiteral("Pay"), params);
    QByteArray array = QJsonDocument(data).toJson();
    array.replace("????", mAccountData);
    array.replace("-666", serializeAmount(amount));
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftWalletAPIv3::receivePayResponse);
}


void GraftWalletAPIv3::buildRtaTransaction(const QString &pid, const QString &dstAddress, const QStringList &keys, const QStringList &wallets, double amount, double feeRatio, int blockNumber)
{
    mRequest.setUrl(nextAddress());
    
    QJsonObject params;
    params.insert(QStringLiteral("Account"), accountPlaceholder());
    params.insert(QStringLiteral("PaymentID"), pid);
    params.insert(QStringLiteral("Recipient"), dstAddress);
    params.insert(QStringLiteral("Keys"), QJsonArray::fromStringList(keys));
    params.insert(QStringLiteral("Wallets"), QJsonArray::fromStringList(wallets));
    params.insert(QStringLiteral("BlockNum"), blockNumber);
    params.insert(QStringLiteral("Amount"), -666);
    params.insert(QStringLiteral("FeeRatio"), feeRatio);
    
    
    QJsonObject data = buildMessage(QStringLiteral("BuildRtaTransaction"), params);
    QByteArray array = QJsonDocument(data).toJson();
    array.replace("????", mAccountData);
    array.replace("-666", serializeAmount(amount));
    qDebug() << __FUNCTION__ << " calling: " << mRequest.url() << " with " << array;
    {
        QString fn(__FUNCTION__);
        fn += ".json";
        QFile f(fn);
        f.open(QIODevice::WriteOnly);
        f.write(array);
    }
    
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftWalletAPIv3::receiveBuildRtaTransactionResponse);
    
}

void GraftWalletAPIv3::submitRtaTx(const QString &encryptedTxBlob, const QString &encryptedTxKey)
{
    mRequest.setUrl(nextAddress("pay"));
    QJsonObject params;
    params.insert(QStringLiteral("TxKey"), encryptedTxKey);
    params.insert(QStringLiteral("TxBlob"), encryptedTxBlob);
    QByteArray array = QJsonDocument(params).toJson(QJsonDocument::Compact);
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    qDebug() << "Calling pay with payload: " << array;
    connect(reply, &QNetworkReply::finished, this, &GraftWalletAPIv3::receiveSubmitRtaTx);
}

void GraftWalletAPIv3::getPaymentData()
{

    mRetries = 0;
    mRequest.setUrl(nextAddress(QStringLiteral("get_payment_data")));
    QJsonObject params;
    params.insert(QStringLiteral("PaymentID"), mLastPID);
    params.insert(QStringLiteral("BlockHeight"), QJsonValue((int)mLastBlockHeight));
    params.insert(QStringLiteral("BlockHash"), mLastBlockHash);
    qDebug() << __FUNCTION__ << ", requesting url: " << mRequest.url() << " with data: " << params;
    
    QByteArray array = QJsonDocument(params).toJson();
    
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftWalletAPIv3::receivePaymentDataResponse);
}


void GraftWalletAPIv3::receivePaymentDataResponse()
{
    mLastError.clear();
    qDebug() << "/get_payment_data Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    
    QJsonObject object;
    
    // specific case: in case wallet is not called /pay yet - supernode will respond with "Payment ID is invalid" error
    int httpStatusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    
    do {
        /// in case httpStatusCode == 202 - means we don't have a payment data yet;
        qDebug() << __FUNCTION__ <<  " http status: " << httpStatusCode;
        if (httpStatusCode == 202) {
            // TODO: try again until sale timeout
            qDebug() << "Try again here. or returns status to try again?";
            if (mTimer.hasExpired(PAYMENT_DATA_EXPIRE_TIME_MS)) {
                qWarning() << "get_payment_data expired";
                
                emit paymentDataReceived(1, PaymentData(), NodeAddress());
            } else {
                QTimer::singleShot(500, this, [this]() {
                   getPaymentData(); 
                });
            }

        } else if (reply->error() == QNetworkReply::NoError && httpStatusCode == 200) {
            QByteArray rawData = reply->readAll();
            if (!rawData.isEmpty()) {
                object = QJsonDocument::fromJson(rawData).object();
            }
            QJsonObject paymentDataJson = object.value("paymentData").toObject();
            PaymentData paymentData = PaymentData::fromJson(paymentDataJson);
            QJsonObject walletProxyJson  = object.value("WalletProxy").toObject();
            NodeAddress walletProxy = NodeAddress::fromJson(walletProxyJson);
            emit paymentDataReceived(0, paymentData, walletProxy);
        } else {
            
            mLastError = QString("Failed to call '%1' - '%2'")
                    .arg(mRequest.url().toString())
                    .arg(reply->errorString());
            qCritical() << mLastError << ", reply: " << reply->readAll();
            emit error(mLastError);
        }    
    } while (false);
    
    
    reply->deleteLater();
    reply = nullptr;
}

void GraftWalletAPIv3::receiveRejectPayResponse()
{
    mLastError.clear();
    qDebug() << "RejectPay Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        emit rejectPayReceived(object.value(QLatin1String("Result")).toInt());
    }
    else
    {
        QNetworkReply *reply = retry();
        if (reply)
        {
            connect(reply, &QNetworkReply::finished, this,
                    &GraftWalletAPIv3::receiveRejectPayResponse);
        }
    }
}

void GraftWalletAPIv3::receivePayResponse()
{
    mLastError.clear();
    qDebug() << "Pay Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        emit payReceived(object.value(QLatin1String("Result")).toInt());
    }
    else
    {
        QNetworkReply *reply = retry();
        if (reply)
        {
            connect(reply, &QNetworkReply::finished, this, &GraftWalletAPIv3::receivePayResponse);
        }
    }
}


void GraftWalletAPIv3::receiveBuildRtaTransactionResponse()
{
    qDebug() << "BuildRtaTransaction Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    qDebug() << __FUNCTION__ << ", reply: " << object << ", error: " << mLastError;
   
    if (!object.isEmpty())
    {
        QStringList ptxBlobs;
        QVariantList tmp = object.value(QLatin1String("PtxBlobs")).toArray().toVariantList();
        for (const auto & item : tmp) {
            ptxBlobs.append(item.toString());
        }
        emit buildRtaTransactionReceived(object.value(QLatin1String("Result")).toInt(),
                                  object.value(QLatin1String("ErrorMessage")).toString(),
                                  ptxBlobs,
                                  object.value(QLatin1String("RecipientAmount")).toVariant().toLongLong(),
                                  object.value(QLatin1String("FeePerDestination")).toVariant().toLongLong()
                                  );
    } else {
        emit error(mLastError);
    }
}

void GraftWalletAPIv3::receiveGetSupernodeInfo()
{
    mLastError.clear();
    qDebug() << "core/get_supernode_info Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    
    
    if (reply->error() == QNetworkReply::NoError) {
        QJsonObject object;
        QByteArray rawData = reply->readAll();
        if (!rawData.isEmpty()) {
            object = QJsonDocument::fromJson(rawData).object();
            QJsonArray supernodes = object.value("output").toArray();
            QStringList wallets;
            for (const auto item : supernodes) {
                wallets.push_back(item.toObject().value("Address").toString());
            }
            qDebug() << wallets;
            emit supernodeInfoReceived(wallets);
        } else {
            mLastError = QString("Empty output from '%1'").arg(mRequest.url().toString());
            emit error(mLastError);
        }
                    
    } else {
        mLastError = QString("Failed to call '%1' - '%2'")
                .arg(mRequest.url().toString())
                .arg(reply->errorString());
        emit error(mLastError);
    }
    
    reply->deleteLater();
    reply = nullptr;
}

void GraftWalletAPIv3::receiveSubmitRtaTx()
{
    qDebug() << "pay Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    int httpStatusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    if (reply->error() == QNetworkReply::NoError) {
        // expected http status 202 for this call
        if (httpStatusCode == 202) {
            emit payReceived(0); // reusing "pay" handlers
        } else {
            mLastError = QString("Pay failed with status '%1'").arg(httpStatusCode);
        }
    } else {
        mLastError = QString("Failed to call '%1' - '%2'")
                .arg(mRequest.url().toString())
                .arg(reply->errorString());
        emit error(mLastError);
    }
    
}

