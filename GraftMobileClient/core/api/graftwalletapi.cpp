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
    QJsonObject data;
    data.insert(QStringLiteral("Call"), QStringLiteral("ReadyToPay"));
    data.insert(QStringLiteral("PID"), pid);
    data.insert(QStringLiteral("KeyImage"), keyImage);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    mReply = mManager->post(mRequest, array);
    connect(mReply, &QNetworkReply::finished, this, &GraftWalletAPI::receiveReadyToPayResponse);
}

void GraftWalletAPI::rejectPay(const QString &pid)
{
    QJsonObject data;
    data.insert(QStringLiteral("Call"), QStringLiteral("RejectPay"));
    data.insert(QStringLiteral("PID"), pid);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    mReply = mManager->post(mRequest, array);
    connect(mReply, &QNetworkReply::finished, this, &GraftWalletAPI::receiveRejectPayResponse);
}

void GraftWalletAPI::pay(const QString &pid, const QString &transaction)
{
    QJsonObject data;
    data.insert(QStringLiteral("Call"), QStringLiteral("Pay"));
    data.insert(QStringLiteral("PID"), pid);
    data.insert(QStringLiteral("Transaction"), transaction);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    mReply = mManager->post(mRequest, array);
    connect(mReply, &QNetworkReply::finished, this, &GraftWalletAPI::receivePayResponse);
}

void GraftWalletAPI::getPayStatus(const QString &pid)
{
    QJsonObject data;
    data.insert(QStringLiteral("Call"), QStringLiteral("GetPayStatus"));
    data.insert(QStringLiteral("PID"), pid);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    mReply = mManager->post(mRequest, array);
    connect(mReply, &QNetworkReply::finished, this, &GraftWalletAPI::receivePayStatusResponse);
}

void GraftWalletAPI::receiveReadyToPayResponse()
{
    qDebug() << "ReadyToPay Response Received:\nTime: " << mTimer.elapsed();
    QJsonObject object = processReply();
    emit readyToPayReceived(object.value(QLatin1String("Result")).toInt(),
                            object.value(QLatin1String("Transaction")).toString());
}

void GraftWalletAPI::receiveRejectPayResponse()
{
    qDebug() << "RejectPay Response Received:\nTime: " << mTimer.elapsed();
    QJsonObject object = processReply();
    emit rejectPayReceived(object.value(QLatin1String("Result")).toInt());
}

void GraftWalletAPI::receivePayResponse()
{
    qDebug() << "Pay Response Received:\nTime: " << mTimer.elapsed();
    QJsonObject object = processReply();
    emit payReceived(object.value(QLatin1String("Result")).toInt());
}

void GraftWalletAPI::receivePayStatusResponse()
{
    qDebug() << "GetPayStatus Response Received:\nTime: " << mTimer.elapsed();
    QJsonObject object = processReply();
    emit getPayStatusReceived(object.value(QLatin1String("Result")).toInt(),
                              object.value(QLatin1String("PayStatus")).toInt());
}
