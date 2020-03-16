#include "graftwalletapiv3.h"
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>
#include <QTimer>

namespace  {
    static constexpr size_t PAYMENT_DATA_EXPIRE_TIME_MS = 5 * 1000;
}

GraftWalletAPIv3::GraftWalletAPIv3(const QStringList &addresses, const QString &dapiVersion, QObject *parent)
    : GraftGenericAPIv3(addresses, dapiVersion, parent)
{
}

void GraftWalletAPIv3::getPaymentData(const QString &pid, const QString &blockHash, quint64 blockHeight)
{
    
    mRetries = 0;
    
    mRequest.setUrl(nextAddress(QStringLiteral("get_payment_data")));
    mTimer.start();
    
    mLastPID = pid;
    mLastBlockHeight = blockHeight;
    mLastBlockHash  = blockHash;
    
    getPaymentData();
}



void GraftWalletAPIv3::rejectPay(const QString &pid, int blockNum)
{
#if 0
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
    mRetries = 0;
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
    qDebug() << array;
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftWalletAPIv3::receivePayResponse);
}

void GraftWalletAPIv3::getPayStatus(const QString &pid)
{
    QJsonObject params;
    params.insert(QStringLiteral("PaymentID"), pid);
    QJsonObject data = buildMessage(QStringLiteral("GetPayStatus"), params);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftWalletAPIv3::receivePayStatusResponse);
}

void GraftWalletAPIv3::getPaymentData()
{
    QJsonObject params;
    params.insert(QStringLiteral("PaymentID"), mLastPID);
    params.insert(QStringLiteral("BlockHeight"), QJsonValue((int)mLastBlockHeight));
    params.insert(QStringLiteral("BlockHash"), mLastBlockHash);
    
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
        qDebug() << "http status: " << httpStatusCode;
        if (httpStatusCode == 202) {
            // TODO: try again until sale timeout
            qDebug() << "Try again here. or returns status to try again?";
            if (mTimer.hasExpired(PAYMENT_DATA_EXPIRE_TIME_MS)) {
                qDebug() << "get_payment_data expired; TODO: inform GUI";
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

void GraftWalletAPIv3::receivePayStatusResponse()
{
    qDebug() << "GetPayStatus Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        emit getPayStatusReceived(object.value(QLatin1String("Result")).toInt(),
                                  object.value(QLatin1String("Status")).toInt());
    }
}

