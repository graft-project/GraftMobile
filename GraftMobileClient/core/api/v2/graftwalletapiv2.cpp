#include "graftwalletapiv2.h"
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>

GraftWalletAPIv2::GraftWalletAPIv2(const QStringList &addresses, const QString &dapiVersion,
                                   QObject *parent)
    : GraftGenericAPIv2(addresses, dapiVersion, parent)
{
}

void GraftWalletAPIv2::saleDetails(const QString &pid, int blockNumber)
{
    mRetries = 0;
    mRequest.setUrl(nextAddress(QStringLiteral("sale_details")));
    QJsonObject params;
    params.insert(QStringLiteral("PaymentID"), pid);
    params.insert(QStringLiteral("BlockNumber"), blockNumber);
    QJsonObject data = buildMessage(QStringLiteral("sale_details"), params);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftWalletAPIv2::receiveSaleDetailsResponse);
}

void GraftWalletAPIv2::rejectPay(const QString &pid, int blockNum)
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
    connect(reply, &QNetworkReply::finished, this, &GraftWalletAPIv2::receiveRejectPayResponse);
}

void GraftWalletAPIv2::pay(const QString &pid, const QString &address, double amount,
                           int blockNumber, const QByteArrayList &transactions)
{
    mRetries = 0;
    mRequest.setUrl(nextAddress(QStringLiteral("pay")));
    QJsonArray trans;
    for (QByteArray transaction : transactions)
    {
        trans.append(QString(transaction));
    }
    QJsonObject params;
    params.insert(QStringLiteral("Address"), address);
    params.insert(QStringLiteral("PaymentID"), pid);
    params.insert(QStringLiteral("BlockNumber"), blockNumber);
    params.insert(QStringLiteral("Amount"), -666);
    params.insert(QStringLiteral("Transactions"), trans);
    QJsonObject data = buildMessage(QStringLiteral("pay"), params);
    QByteArray array = QJsonDocument(data).toJson();
    array.replace("-666", serializeAmount(amount));
    qDebug() << array;
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftWalletAPIv2::receivePayResponse);
}

void GraftWalletAPIv2::payStatus(const QString &pid, int blockNumber)
{
    mRequest.setUrl(nextAddress(QStringLiteral("pay_status")));
    QJsonObject params;
    params.insert(QStringLiteral("PaymentID"), pid);
    params.insert(QStringLiteral("BlockNumber"), blockNumber);
    QJsonObject data = buildMessage(QStringLiteral("pay_status"), params);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftWalletAPIv2::receivePayStatusResponse);
}

void GraftWalletAPIv2::receiveSaleDetailsResponse()
{
    mLastError.clear();
    qDebug() << "SaleDetails Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        QVector<QPair<QString, QString>> authSample;
        QJsonArray authSampleArray = object.value(QLatin1String("AuthSample")).toArray();
        for (int i = 0; i < authSampleArray.size(); ++i)
        {
            QJsonObject authNode = authSampleArray.at(i).toObject();
            authSample.append(qMakePair(authNode.value(QLatin1String("Address")).toString(),
                                        authNode.value(QLatin1String("Fee")).toString()));
        }
        emit saleDetailsReceived(authSample, object.value(QLatin1String("Details")).toString());
    }
    else
    {
        QNetworkReply *reply = retry();
        if (reply)
        {
            connect(reply, &QNetworkReply::finished, this,
                    &GraftWalletAPIv2::receiveSaleDetailsResponse);
        }
    }
}

void GraftWalletAPIv2::receiveRejectPayResponse()
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
                    &GraftWalletAPIv2::receiveRejectPayResponse);
        }
    }
}

void GraftWalletAPIv2::receivePayResponse()
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
            connect(reply, &QNetworkReply::finished, this, &GraftWalletAPIv2::receivePayResponse);
        }
    }
}

void GraftWalletAPIv2::receivePayStatusResponse()
{
    qDebug() << "PayStatus Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        emit payStatusReceived(object.value(QLatin1String("Status")).toInt());
    }
}
