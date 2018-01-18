#include "graftposapi.h"
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>

GraftPOSAPI::GraftPOSAPI(const QStringList &addresses, const QString &dapiVersion, QObject *parent)
    : GraftGenericAPI(addresses, dapiVersion, parent)
{
}

void GraftPOSAPI::sale(const QString &address, const QString &viewKey, double amount,
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
    connect(reply, &QNetworkReply::finished, this, &GraftPOSAPI::receiveSaleResponse);
}

void GraftPOSAPI::rejectSale(const QString &pid)
{
    mRetries = 0;
    QJsonObject params;
    params.insert(QStringLiteral("PaymentID"), pid);
    QJsonObject data = buildMessage(QStringLiteral("PosRejectSale"), params);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftPOSAPI::receiveRejectSaleResponse);
}

void GraftPOSAPI::getSaleStatus(const QString &pid)
{
    QJsonObject params;
    params.insert(QStringLiteral("PaymentID"), pid);
    QJsonObject data = buildMessage(QStringLiteral("GetSaleStatus"), params);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftPOSAPI::receiveSaleStatusResponse);
}

void GraftPOSAPI::receiveSaleResponse()
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
            connect(reply, &QNetworkReply::finished, this, &GraftPOSAPI::receiveSaleResponse);
        }
    }
}

void GraftPOSAPI::receiveRejectSaleResponse()
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
            connect(reply, &QNetworkReply::finished, this, &GraftPOSAPI::receiveRejectSaleResponse);
        }
    }
}

void GraftPOSAPI::receiveSaleStatusResponse()
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
