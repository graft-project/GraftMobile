#include "graftposapiv3.h"
#include "libcncrypto/crypto.h"

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>

GraftPOSAPIv3::GraftPOSAPIv3(const QStringList &addresses, const QString &dapiVersion,
                             QObject *parent)
    : GraftGenericAPIv3(addresses, dapiVersion, parent)
{
}

void GraftPOSAPIv3::sale(const QString &address, const QString &viewKey, double amount,
                       const QString &saleDetails)
{
    mRetries = 0;
    QJsonObject params;
    params.insert(QStringLiteral("POSAddress"), address);
    params.insert(QStringLiteral("POSViewKey"), viewKey);
    params.insert(QStringLiteral("POSSaleDetails"), saleDetails);
    params.insert(QStringLiteral("Amount"), -666);
    QJsonObject data = buildMessage(QStringLiteral("Sale"), params);
    QByteArray array = QJsonDocument(data).toJson();
    array.replace("-666", serializeAmount(amount));
    mTimer.start();
    qDebug() << array;
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftPOSAPIv3::receiveSaleResponse);
}

void GraftPOSAPIv3::rejectSale(const QString &pid)
{
    mRetries = 0;
    QJsonObject params;
    params.insert(QStringLiteral("PaymentID"), pid);
    QJsonObject data = buildMessage(QStringLiteral("PosRejectSale"), params);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftPOSAPIv3::receiveRejectSaleResponse);
}

void GraftPOSAPIv3::getSaleStatus(const QString &pid)
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
    crypto::public_key pub_key;
    crypto::generate_keys(pub_key, m_secret_key);
    
}

void GraftPOSAPIv3::receiveSaleResponse()
{
    mLastError.clear();
    qDebug() << "Sale Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
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
    qDebug() << "GetSaleStatus Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        emit getSaleStatusResponseReceived(object.value(QLatin1String("Result")).toInt(),
                                           object.value(QLatin1String("Status")).toInt());
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
    result.NodeAddress = GraftGenericAPIv3::NodeAddress::fromJson(arg.value("NodeAddress").toObject());
    return result;
}
