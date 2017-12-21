#include "graftposapi.h"
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>

GraftPOSAPI::GraftPOSAPI(const QUrl &url, QObject *parent)
    : GraftGenericAPI(url, parent)
{
}

void GraftPOSAPI::sale(const QString &address, const QString &viewKey, double amount,
                       const QString &saleDetails)
{
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
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftPOSAPI::receiveSaleResponse);
}

void GraftPOSAPI::rejectSale(const QString &pid)
{
    QJsonObject params;
    params.insert(QStringLiteral("PaymentID"), pid);
    QJsonObject data = buildMessage(QStringLiteral("PosRejectSale"), params);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
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
    qDebug() << "Sale Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        emit saleResponseReceived(object.value(QLatin1String("Result")).toInt(),
                                  object.value(QLatin1String("PaymentID")).toString(),
                                  object.value(QLatin1String("BlockNum")).toInt());
    }
}

void GraftPOSAPI::receiveRejectSaleResponse()
{
    qDebug() << "RejectSale Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        emit rejectSaleResponseReceived(object.value(QLatin1String("Result")).toInt());
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
