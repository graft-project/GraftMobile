#include "graftwalletapi.h"
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>

GraftWalletAPI::GraftWalletAPI(const QUrl &url, QObject *parent)
    : GraftGenericAPI(url, parent)
{
}

void GraftWalletAPI::readyToPay(const QString &pid, const QString &keyImage)
{
    QJsonObject params;
    params.insert(QStringLiteral("pid"), pid);
    params.insert(QStringLiteral("key_image"), keyImage);
    QJsonObject data = buildMessage(QStringLiteral("ReadyToPay"), params);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftWalletAPI::receiveReadyToPayResponse);
}

void GraftWalletAPI::rejectPay(const QString &pid)
{
    QJsonObject params;
    params.insert(QStringLiteral("pid"), pid);
    QJsonObject data = buildMessage(QStringLiteral("RejectPay"), params);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftWalletAPI::receiveRejectPayResponse);
}

void GraftWalletAPI::pay(const QString &pid, const QString &address, double amount)
{
    QJsonObject trans;
    trans.insert(QStringLiteral("address"), address);
    trans.insert(QStringLiteral("amount"), (int)amount);
    QJsonObject params;
    params.insert(QStringLiteral("pid"), pid);
    params.insert(QStringLiteral("account"), accountPlaceholder());
    params.insert(QStringLiteral("transaction"), trans);
    QJsonObject data = buildMessage(QStringLiteral("Pay"), params);
    QByteArray array = QJsonDocument(data).toJson();
    array.replace("????", mAccountData);
    mTimer.start();
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftWalletAPI::receivePayResponse);
}

void GraftWalletAPI::getPayStatus(const QString &pid)
{
    QJsonObject params;
    params.insert(QStringLiteral("pid"), pid);
    QJsonObject data = buildMessage(QStringLiteral("GetPayStatus"), params);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftWalletAPI::receivePayStatusResponse);
}

void GraftWalletAPI::receiveReadyToPayResponse()
{
    qDebug() << "ReadyToPay Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        emit readyToPayReceived(object.value(QLatin1String("result")).toInt(),
                                object.value(QLatin1String("data")).toString());
    }
}

void GraftWalletAPI::receiveRejectPayResponse()
{
    qDebug() << "RejectPay Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        emit rejectPayReceived(object.value(QLatin1String("result")).toInt());
    }
}

void GraftWalletAPI::receivePayResponse()
{
    qDebug() << "Pay Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        emit payReceived(object.value(QLatin1String("result")).toInt());
    }
}

void GraftWalletAPI::receivePayStatusResponse()
{
    qDebug() << "GetPayStatus Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        emit getPayStatusReceived(object.value(QLatin1String("result")).toInt(),
                                  object.value(QLatin1String("pay_status")).toInt());
    }
}
