#include "graftgenericapi.h"
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>

GraftGenericAPI::GraftGenericAPI(const QUrl &url, QObject *parent)
    : QObject(parent)
    ,mReply(nullptr)
{
    mManager = new QNetworkAccessManager(this);
    mRequest = QNetworkRequest(url);
    mRequest.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
}

GraftGenericAPI::~GraftGenericAPI()
{
    if (mReply)
    {
        mReply->deleteLater();
    }
}

void GraftGenericAPI::setUrl(const QUrl &url)
{
    mRequest.setUrl(url);
}

void GraftGenericAPI::setAccountData(const QByteArray &accountData, const QString &password)
{
    mAccountData = accountData;
    mPassword = mPassword;
}

QByteArray GraftGenericAPI::accountData() const
{
    return mAccountData;
}

QString GraftGenericAPI::password() const
{
    return mPassword;
}

void GraftGenericAPI::createAccount(const QString &password)
{
    mPassword = password;
    QJsonObject params;
    params.insert(QStringLiteral("password"), mPassword);
    params.insert(QStringLiteral("language"), QStringLiteral("English"));
    QJsonObject data = buildMessage(QStringLiteral("CreateAccount"), params);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    mReply = mManager->post(mRequest, array);
    connect(mReply, &QNetworkReply::finished, this, &GraftGenericAPI::receiveCreateAccountResponse);
}

void GraftGenericAPI::getBalance()
{
    if (mAccountData.isEmpty())
    {
        qDebug() << "GraftGenericAPI: Account Data is empty.";
        emit error();
        return;
    }
    QJsonObject params;
    params.insert(QStringLiteral("password"), mPassword);
    params.insert(QStringLiteral("account"), accountPlaceholder());
    QJsonObject data = buildMessage(QStringLiteral("GetWalletBalance"), params);
    QByteArray array = QJsonDocument(data).toJson();
    array.replace(accountPlaceholder(), mAccountData);
    mTimer.start();
    mReply = mManager->post(mRequest, array);
    connect(mReply, &QNetworkReply::finished, this, &GraftGenericAPI::receiveGetBalanceResponse);
}

void GraftGenericAPI::getPaymentAddress(const QString &pid)
{
    if (mAccountData.isEmpty())
    {
        qDebug() << "GraftGenericAPI: Account Data is empty.";
        emit error();
        return;
    }
    QJsonObject params;
    params.insert(QStringLiteral("payment_id"), pid);
    params.insert(QStringLiteral("password"), mPassword);
    params.insert(QStringLiteral("account"), accountPlaceholder());
    QJsonObject data = buildMessage(QStringLiteral("GetPaymentAddress"), params);
    QByteArray array = QJsonDocument(data).toJson();
    array.replace(accountPlaceholder(), mAccountData);
    mTimer.start();
    mReply = mManager->post(mRequest, array);
    connect(mReply, &QNetworkReply::finished,
            this, &GraftGenericAPI::receiveGetPaymentAddressResponse);

}

double GraftGenericAPI::toCoins(int atomic)
{
    return (1.0 * atomic) / 1000000000000.0;
}

int GraftGenericAPI::toAtomic(double coins)
{
    return (int)(coins * 1000000000000);
}

QString GraftGenericAPI::accountPlaceholder() const
{
    return QString("????");
}

QJsonObject GraftGenericAPI::buildMessage(const QString &key, const QJsonObject &params) const
{
    QJsonObject data;
    data.insert(QStringLiteral("jsonrpc"), QStringLiteral("2.0"));
    data.insert(QStringLiteral("id"), QStringLiteral("0"));
    data.insert(QStringLiteral("method"), key);
    if (!params.isEmpty())
    {
        data.insert(QStringLiteral("params"), params);
    }
    return data;
}

QJsonObject GraftGenericAPI::processReply()
{
    QJsonObject object;
    if (mReply->error() == QNetworkReply::NoError)
    {
        QByteArray rawData = mReply->readAll();
        if (!rawData.isEmpty())
        {
            QJsonObject response = QJsonDocument::fromJson(rawData).object();
            qDebug() << response.toVariantMap();
            if (response.contains(QLatin1String("result")))
            {
                object = response.value(QLatin1String("result")).toObject();
            }
            else
            {
                qDebug() << "Error" << response.toVariantMap();
            }
        }
    }
    mReply->deleteLater();
    mReply = nullptr;
    if (object.isEmpty())
    {
        emit error();
    }
    return object;
}

void GraftGenericAPI::receiveCreateAccountResponse()
{
    qDebug() << "CreateAccount Response Received:\nTime: " << mTimer.elapsed();
    QByteArray arr = mReply->readAll();
    QByteArray temp("\"account\": \"");
    int index = arr.indexOf(temp);
    int end = arr.indexOf("\"\r\n  }\r\n}");
    QByteArray accountArr;
    for (int i = index + temp.size(); i < end; ++i)
    {
        accountArr.append(arr.at(i));
    }
    mAccountData = accountArr;
    emit createAccountReceived(mAccountData, mPassword);
}

void GraftGenericAPI::receiveGetBalanceResponse()
{
    qDebug() << "GetBalance Response Received:\nTime: " << mTimer.elapsed();
    QJsonObject object = processReply();
    if (!object.isEmpty())
    {
        emit getBalanceReceived(toCoins(object.value(QLatin1String("balance")).toInt()),
                                toCoins(object.value(QLatin1String("unlocked_balance")).toInt()));
    }
}

void GraftGenericAPI::receiveGetPaymentAddressResponse()
{
    qDebug() << "GetPaymentAddress Response Received:\nTime: " << mTimer.elapsed();
    QJsonObject object = processReply();
    if (!object.isEmpty())
    {
        emit getPaymentAddressReceived(object.value(QLatin1String("payment_address")).toString(),
                                       object.value(QLatin1String("payment_id")).toString());
    }
}
