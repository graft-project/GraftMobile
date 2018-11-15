#include "graftposapiv2.h"
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>

GraftPOSAPIv2::GraftPOSAPIv2(const QStringList &addresses, const QString &dapiVersion,
                             QObject *parent)
    : GraftGenericAPIv2(addresses, dapiVersion, parent)
{
}

void GraftPOSAPIv2::sale(const QString &address, double amount, const QString &saleDetails)
{
    mRetries = 0;
    mRequest.setUrl(nextAddress(QStringLiteral("sale")));
    QJsonObject params;
    params.insert(QStringLiteral("Address"), address);
    params.insert(QStringLiteral("SaleDetails"), saleDetails);
    params.insert(QStringLiteral("Amount"), -666);
    QJsonObject data = buildMessage(QStringLiteral("sale"), params);
    QByteArray array = QJsonDocument(data).toJson();
    array.replace("-666", serializeAmount(amount));
    mTimer.start();
    qDebug() << array;
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftPOSAPIv2::receiveSaleResponse);
}

void GraftPOSAPIv2::rejectSale(const QString &pid)
{
    mRetries = 0;
    QJsonObject params;
    params.insert(QStringLiteral("PaymentID"), pid);
    QJsonObject data = buildMessage(QStringLiteral("PosRejectSale"), params);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftPOSAPIv2::receiveRejectSaleResponse);
}

void GraftPOSAPIv2::saleStatus(const QString &pid, int blockNumber)
{
    mRequest.setUrl(nextAddress(QStringLiteral("sale_status")));
    QJsonObject params;
    params.insert(QStringLiteral("PaymentID"), pid);
    params.insert(QStringLiteral("BlockNumber"), blockNumber);
    QJsonObject data = buildMessage(QStringLiteral("sale_status"), params);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftPOSAPIv2::receiveSaleStatusResponse);
}

void GraftPOSAPIv2::receiveSaleResponse()
{
    mLastError.clear();
    qDebug() << "Sale Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        emit saleResponseReceived(object.value(QLatin1String("PaymentID")).toString(),
                                  object.value(QLatin1String("BlockNumber")).toInt());
    }
    else
    {
        QNetworkReply *reply = retry();
        if (reply)
        {
            connect(reply, &QNetworkReply::finished, this, &GraftPOSAPIv2::receiveSaleResponse);
        }
    }
}

void GraftPOSAPIv2::receiveRejectSaleResponse()
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
            connect(reply, &QNetworkReply::finished, this, &GraftPOSAPIv2::receiveRejectSaleResponse);
        }
    }
}

void GraftPOSAPIv2::receiveSaleStatusResponse()
{
    qDebug() << "SaleStatus Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        emit saleStatusResponseReceived(object.value(QLatin1String("Status")).toInt());
    }
}
