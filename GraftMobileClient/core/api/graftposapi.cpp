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
    QJsonObject data;
    data.insert(QStringLiteral("Call"), QStringLiteral("Sale"));
    data.insert(QStringLiteral("PID"), pid);
    data.insert(QStringLiteral("Transaction"), transaction);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    mReply = mManager->post(mRequest, array);
    connect(mReply, &QNetworkReply::finished, this, &GraftPOSAPI::receiveSaleResponse);
}

void GraftPOSAPI::getSaleStatus(const QString &pid)
{
    QJsonObject data;
    data.insert(QStringLiteral("Call"), QStringLiteral("GetSaleStatus"));
    data.insert(QStringLiteral("PID"), pid);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    mReply = mManager->post(mRequest, array);
    connect(mReply, &QNetworkReply::finished, this, &GraftPOSAPI::receiveSaleStatusResponse);
}

void GraftPOSAPI::receiveSaleResponse()
{
    qDebug() << "Sale Response Received:\nTime: " << mTimer.elapsed();
    QJsonObject object = processReply();
    if (!object.isEmpty())
    {
        emit saleResponseReceived(object.value(QLatin1String("Result")).toInt());
    }
}

void GraftPOSAPI::receiveSaleStatusResponse()
{
    qDebug() << "GetSaleStatus Response Received:\nTime: " << mTimer.elapsed();
    QJsonObject object = processReply();
    if (!object.isEmpty())
    {
        emit getSaleStatusResponseReceived(object.value(QLatin1String("Result")).toInt(),
                                           object.value(QLatin1String("SaleStatus")).toInt());
    }
}
