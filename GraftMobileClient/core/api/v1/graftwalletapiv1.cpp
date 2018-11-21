#include "graftwalletapiv1.h"
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDebug>

GraftWalletAPIv1::GraftWalletAPIv1(const QStringList &addresses, const QString &dapiVersion, QObject *parent)
    : GraftGenericAPIv1(addresses, dapiVersion, parent)
{
}

void GraftWalletAPIv1::getPOSData(const QString &pid, int blockNum)
{
    mRetries = 0;
    QJsonObject params;
    params.insert(QStringLiteral("PaymentID"), pid);
    params.insert(QStringLiteral("BlockNum"), blockNum);
    QJsonObject data = buildMessage(QStringLiteral("WalletGetPosData"), params);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftWalletAPIv1::receiveGetPOSDataResponse);
}

void GraftWalletAPIv1::rejectPay(const QString &pid, int blockNum)
{
    mRetries = 0;
    QJsonObject params;
    params.insert(QStringLiteral("PaymentID"), pid);
    params.insert(QStringLiteral("BlockNum"), blockNum);
    QJsonObject data = buildMessage(QStringLiteral("WalletRejectPay"), params);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftWalletAPIv1::receiveRejectPayResponse);
}

void GraftWalletAPIv1::pay(const QString &pid, const QString &address, double amount, int blockNum)
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
    connect(reply, &QNetworkReply::finished, this, &GraftWalletAPIv1::receivePayResponse);
}

void GraftWalletAPIv1::getPayStatus(const QString &pid)
{
    QJsonObject params;
    params.insert(QStringLiteral("PaymentID"), pid);
    QJsonObject data = buildMessage(QStringLiteral("GetPayStatus"), params);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftWalletAPIv1::receivePayStatusResponse);
}

void GraftWalletAPIv1::receiveGetPOSDataResponse()
{
    mLastError.clear();
    qDebug() << "GetPOSData Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        emit getPOSDataReceived(object.value(QLatin1String("Result")).toInt(),
                                object.value(QLatin1String("POSSaleDetails")).toString());
    }
    else
    {
        QNetworkReply *reply = retry();
        if (reply)
        {
            connect(reply, &QNetworkReply::finished, this,
                    &GraftWalletAPIv1::receiveGetPOSDataResponse);
        }
    }
}

void GraftWalletAPIv1::receiveRejectPayResponse()
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
                    &GraftWalletAPIv1::receiveRejectPayResponse);
        }
    }
}

void GraftWalletAPIv1::receivePayResponse()
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
            connect(reply, &QNetworkReply::finished, this, &GraftWalletAPIv1::receivePayResponse);
        }
    }
}

void GraftWalletAPIv1::receivePayStatusResponse()
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
