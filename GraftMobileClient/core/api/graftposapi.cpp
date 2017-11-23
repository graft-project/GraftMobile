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

void GraftPOSAPI::sale(const QString &pid, const QString &transaction)
{
    QJsonObject params;
    params.insert(QStringLiteral("pid"), pid);
    params.insert(QStringLiteral("data"), transaction);
    QJsonObject data = buildMessage(QStringLiteral("Sale"), params);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftPOSAPI::receiveSaleResponse);
}

void GraftPOSAPI::rejectSale(const QString &pid)
{
    QJsonObject params;
    params.insert(QStringLiteral("pid"), pid);
    QJsonObject data = buildMessage(QStringLiteral("RejectSale"), params);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftPOSAPI::receiveRejectSaleResponse);
}

void GraftPOSAPI::getSaleStatus(const QString &pid)
{
    QJsonObject params;
    params.insert(QStringLiteral("pid"), pid);
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
        emit saleResponseReceived(object.value(QLatin1String("result")).toInt());
    }
}

void GraftPOSAPI::receiveRejectSaleResponse()
{
    qDebug() << "RejectSale Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        emit rejectSaleResponseReceived(object.value(QLatin1String("result")).toInt());
    }
}

void GraftPOSAPI::receiveSaleStatusResponse()
{
    qDebug() << "GetSaleStatus Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        emit getSaleStatusResponseReceived(object.value(QLatin1String("result")).toInt(),
                                           object.value(QLatin1String("sale_status")).toInt());
    }
}
