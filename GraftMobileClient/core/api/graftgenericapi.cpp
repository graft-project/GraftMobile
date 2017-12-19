#include "graftgenericapi.h"
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>

GraftGenericAPI::GraftGenericAPI(const QUrl &url, QObject *parent)
    : QObject(parent)
{
    mManager = new QNetworkAccessManager(this);
    mRequest = QNetworkRequest(url);
    mRequest.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
}

GraftGenericAPI::~GraftGenericAPI()
{
}

void GraftGenericAPI::setUrl(const QUrl &url)
{
    mRequest.setUrl(url);
}

void GraftGenericAPI::setAccountData(const QByteArray &accountData, const QString &password)
{
    mAccountData = accountData;
    mPassword = password;
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
    params.insert(QStringLiteral("Password"), mPassword);
    params.insert(QStringLiteral("Language"), QStringLiteral("English"));
    QJsonObject data = buildMessage(QStringLiteral("CreateAccount"), params);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftGenericAPI::receiveCreateAccountResponse);
}

void GraftGenericAPI::getBalance()
{
    if (mAccountData.isEmpty())
    {
        qDebug() << "GraftGenericAPI: Account Data is empty.";
        emit error(QStringLiteral("Couldn't find account data."));
        return;
    }
    QJsonObject params;
    params.insert(QStringLiteral("Password"), mPassword);
    params.insert(QStringLiteral("Account"), accountPlaceholder());
    QJsonObject data = buildMessage(QStringLiteral("GetWalletBalance"), params);
    QByteArray array = QJsonDocument(data).toJson();
    array.replace(accountPlaceholder(), mAccountData);
    mTimer.start();
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftGenericAPI::receiveGetBalanceResponse);
}

void GraftGenericAPI::getSeed()
{
    if (mAccountData.isEmpty())
    {
        qDebug() << "GraftGenericAPI: Account Data is empty.";
        emit error(QStringLiteral("Couldn't find account data."));
        return;
    }
    QJsonObject params;
    params.insert(QStringLiteral("Password"), mPassword);
    params.insert(QStringLiteral("Account"), accountPlaceholder());
    params.insert(QStringLiteral("Language"), QStringLiteral("English"));
    QJsonObject data = buildMessage(QStringLiteral("GetSeed"), params);
    QByteArray array = QJsonDocument(data).toJson();
    array.replace(accountPlaceholder(), mAccountData);
    mTimer.start();
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftGenericAPI::receiveGetSeedResponse);
}

void GraftGenericAPI::restoreAccount(const QString &seed, const QString &password)
{
    QJsonObject params;
    params.insert(QStringLiteral("Password"), password);
    params.insert(QStringLiteral("Seed"), seed);
    QJsonObject data = buildMessage(QStringLiteral("RestoreAccount"), params);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftGenericAPI::receiveRestoreAccountResponse);
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

QJsonObject GraftGenericAPI::processReply(QNetworkReply *reply)
{
    QJsonObject object;
    qDebug() << reply->error();
    if (reply->error() == QNetworkReply::NoError)
    {
        QByteArray rawData = reply->readAll();
        qDebug() << rawData;
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
                emit error(QStringLiteral("Response error"));
            }
        }
        else
        {
            emit error(QStringLiteral("Couldn't parse request response."));
        }
    }
    else
    {
        emit error(reply->errorString());
    }
    reply->deleteLater();
    reply = nullptr;
    return object;
}

void GraftGenericAPI::receiveCreateAccountResponse()
{
    qDebug() << "CreateAccount Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QByteArray arr = reply->readAll();
    qDebug() << arr;
    reply->deleteLater();
    reply = nullptr;
    QByteArray temp("\"Account\": \"");
    int index = arr.indexOf(temp);
    int end = arr.indexOf("\",\r\n    \"Address\":");
    QByteArray accountArr;
    for (int i = index + temp.size(); i < end; ++i)
    {
        accountArr.append(arr.at(i));
    }
    arr.remove(index + temp.size(), end - (index + temp.size()));
    QString address;
    QString seed;
    QJsonObject response = QJsonDocument::fromJson(arr).object();
    if (response.contains(QLatin1String("result")))
    {
        QJsonObject object = response.value(QLatin1String("result")).toObject();
        address = object.value(QLatin1String("Address")).toString();
        seed = object.value(QLatin1String("Seed")).toString();
    }
    else
    {
        emit error(QStringLiteral("Response error"));
        return;
    }
    if (accountArr.isEmpty() || address.isEmpty())
    {
        emit error(QStringLiteral("Couldn't get account data!"));
        return;
    }
    mAccountData = accountArr;
    qDebug() << mAccountData << address;
    emit createAccountReceived(mAccountData, mPassword, address, seed);
}

void GraftGenericAPI::receiveGetBalanceResponse()
{
    qDebug() << "GetBalance Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        emit getBalanceReceived(toCoins(object.value(QLatin1String("balance")).toInt()),
                                toCoins(object.value(QLatin1String("unlocked_balance")).toInt()));
    }
}

void GraftGenericAPI::receiveGetSeedResponse()
{
    qDebug() << "GetSeed Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        emit getSeedReceived(object.value(QLatin1String("Seed")).toString());
    }
}

void GraftGenericAPI::receiveRestoreAccountResponse()
{
    qDebug() << "RestoreAccount Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QByteArray arr = reply->readAll();
    reply->deleteLater();
    reply = nullptr;
    QByteArray temp("\"Account\": \"");
    int index = arr.indexOf(temp);
    int end = arr.indexOf("\",\r\n    \"Address\":");
    QByteArray accountArr;
    for (int i = index + temp.size(); i < end; ++i)
    {
        accountArr.append(arr.at(i));
    }
    arr.remove(index + temp.size(), end - (index + temp.size()));
    QString address;
    QString seed;
    QJsonObject response = QJsonDocument::fromJson(arr).object();
    if (response.contains(QLatin1String("result")))
    {
        QJsonObject object = response.value(QLatin1String("result")).toObject();
        address = object.value(QLatin1String("Address")).toString();
        seed = object.value(QLatin1String("Seed")).toString();
    }
    else
    {
        emit error(QStringLiteral("Response error"));
        return;
    }
    if (accountArr.isEmpty() || address.isEmpty())
    {
        emit error(QStringLiteral("Couldn't get account data!"));
        return;
    }
    mAccountData = accountArr;
    qDebug() << mAccountData << address;
    emit restoreAccountReceived(mAccountData, mPassword, address, seed);
}
