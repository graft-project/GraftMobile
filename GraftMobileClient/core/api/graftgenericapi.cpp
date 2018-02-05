#include "graftgenericapi.h"
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include "../config.h"

GraftGenericAPI::GraftGenericAPI(const QStringList &addresses, const QString &dapiVersion,
                                 QObject *parent)
    : QObject(parent)
    ,mDAPIVersion(dapiVersion)
{
    mRetries = 0;
    mCurrentAddress = -1;
    mAddresses = addresses;
    mManager = new QNetworkAccessManager(this);
    mRequest = QNetworkRequest(nextAddress());
    mRequest.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
}

GraftGenericAPI::~GraftGenericAPI()
{
}

void GraftGenericAPI::changeAddresses(const QStringList &addresses)
{
    mAddresses = addresses;
    mCurrentAddress = -1;
    mRequest.setUrl(nextAddress());
}

void GraftGenericAPI::setDAPIVersion(const QString &version)
{
    mDAPIVersion = version;
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
    mRetries = 0;
    mPassword = password;
    QJsonObject params;
    params.insert(QStringLiteral("Password"), mPassword);
    params.insert(QStringLiteral("Language"), QStringLiteral("English"));
    QJsonObject data = buildMessage(QStringLiteral("CreateAccount"), params);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftGenericAPI::receiveCreateAccountResponse);
}

void GraftGenericAPI::getBalance()
{
    mRetries = 0;
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
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftGenericAPI::receiveGetBalanceResponse);
}

void GraftGenericAPI::getSeed()
{
    mRetries = 0;
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
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftGenericAPI::receiveGetSeedResponse);
}

void GraftGenericAPI::restoreAccount(const QString &seed, const QString &password)
{
    mRetries = 0;
    mPassword = password;
    QJsonObject params;
    params.insert(QStringLiteral("Password"), password);
    params.insert(QStringLiteral("Seed"), seed);
    QJsonObject data = buildMessage(QStringLiteral("RestoreAccount"), params);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftGenericAPI::receiveRestoreAccountResponse);
}

void GraftGenericAPI::transferFee(const QString &address, const QString &amount)
{
    mRetries = 0;
    if (mAccountData.isEmpty())
    {
        qDebug() << "GraftGenericAPI: Account Data is empty.";
        emit error(QStringLiteral("Couldn't find account data."));
        return;
    }
    QJsonObject params;
    params.insert(QStringLiteral("Password"), mPassword);
    params.insert(QStringLiteral("Account"), accountPlaceholder());
    params.insert(QStringLiteral("Address"), address);
    params.insert(QStringLiteral("Amount"), amount);
    QJsonObject data = buildMessage(QStringLiteral("GetTransferFee"), params);
    QByteArray array = QJsonDocument(data).toJson();
    array.replace(accountPlaceholder(), mAccountData);
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftGenericAPI::receiveTransferFeeResponse);
}

void GraftGenericAPI::transfer(const QString &address, const QString &amount)
{
    mRetries = 0;
    if (mAccountData.isEmpty())
    {
        qDebug() << "GraftGenericAPI: Account Data is empty.";
        emit error(QStringLiteral("Couldn't find account data."));
        return;
    }
    QJsonObject params;
    params.insert(QStringLiteral("Password"), mPassword);
    params.insert(QStringLiteral("Account"), accountPlaceholder());
    params.insert(QStringLiteral("Address"), address);
    params.insert(QStringLiteral("Amount"), amount);
    QJsonObject data = buildMessage(QStringLiteral("Transfer"), params);
    QByteArray array = QJsonDocument(data).toJson();
    array.replace(accountPlaceholder(), mAccountData);
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftGenericAPI::receiveTransferResponse);
}

double GraftGenericAPI::toCoins(double atomic)
{
    return (1.0 * atomic) / 10000000000.0;
}

double GraftGenericAPI::toAtomic(double coins)
{
    return coins * 10000000000;
}

QString GraftGenericAPI::accountPlaceholder() const
{
    return QString("????");
}

QByteArray GraftGenericAPI::serializeAmount(double amount) const
{
    QByteArray serializedAmount;
    serializedAmount.setNum(toAtomic(amount), 'f', 0);
    return serializedAmount;
}

QJsonObject GraftGenericAPI::buildMessage(const QString &key, const QJsonObject &params) const
{
    QJsonObject data;
    data.insert(QStringLiteral("jsonrpc"), QStringLiteral("2.0"));
    data.insert(QStringLiteral("id"), QStringLiteral("0"));
    data.insert(QStringLiteral("method"), key);
    data.insert(QStringLiteral("dapi_version"), mDAPIVersion);
    if (!params.isEmpty())
    {
        data.insert(QStringLiteral("params"), params);
    }
    return data;
}

QJsonObject GraftGenericAPI::processReply(QNetworkReply *reply)
{
    QJsonObject object;
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
                mLastError = QLatin1String("Response error");
            }
        }
        else
        {
            mLastError = QLatin1String("Couldn't parse request response.");
        }
    }
    else
    {
        mLastError = reply->errorString();
    }
    reply->deleteLater();
    reply = nullptr;
    return object;
}

QUrl GraftGenericAPI::nextAddress()
{
    mCurrentAddress++;
    if (mCurrentAddress >= mAddresses.count())
    {
        mCurrentAddress = 0;
    }
    return QUrl(scUrl.arg(mAddresses.value(mCurrentAddress)));

}

QNetworkReply *GraftGenericAPI::retry()
{
    if (mRetries < mAddresses.count())
    {
        mRetries++;
        mRequest.setUrl(nextAddress());
        return mManager->post(mRequest, mLastRequest);
    }
    else
    {
        mRetries = 0;
        emit error(QString("Services cannot process request. Reason: %1").arg(mLastError));
    }
    return nullptr;
}

void GraftGenericAPI::receiveCreateAccountResponse()
{
    mLastError.clear();
    qDebug() << "CreateAccount Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    if (reply->error() != QNetworkReply::NoError)
    {
        mLastError = reply->errorString();
        reply->deleteLater();
        reply = nullptr;
    }
    else
    {
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
        QString viewKey;
        QString seed;
        QJsonObject response = QJsonDocument::fromJson(arr).object();
        if (response.contains(QLatin1String("result")))
        {
            QJsonObject object = response.value(QLatin1String("result")).toObject();
            address = object.value(QLatin1String("Address")).toString();
            seed = object.value(QLatin1String("Seed")).toString();
            viewKey = object.value(QLatin1String("ViewKey")).toString();
            if (accountArr.isEmpty() || address.isEmpty())
            {
                mLastError = QLatin1String("Couldn't get account data!");
            }
            else
            {
                mAccountData = accountArr;
                qDebug() << mAccountData << address << viewKey << seed;
                emit createAccountReceived(mAccountData, mPassword, address, viewKey, seed);
            }
        }
        else
        {
            mLastError = QLatin1String("Response error");
        }
    }
    if (!mLastError.isEmpty())
    {
        QNetworkReply *reply = retry();
        if (reply)
        {
            connect(reply, &QNetworkReply::finished,
                    this, &GraftGenericAPI::receiveCreateAccountResponse);
        }
        else
        {
            emit createAccountReceived(mAccountData, mPassword, "", "", "");
        }
    }
}

void GraftGenericAPI::receiveGetBalanceResponse()
{
    mLastError.clear();
    qDebug() << "GetBalance Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        emit getBalanceReceived(toCoins(object.value(QLatin1String("Balance")).toDouble()),
                                toCoins(object.value(QLatin1String("UnlockedBalance")).toDouble()));
    }
    else
    {
        mRequest.setUrl(nextAddress());
    }
}

void GraftGenericAPI::receiveGetSeedResponse()
{
    mLastError.clear();
    qDebug() << "GetSeed Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        emit getSeedReceived(object.value(QLatin1String("Seed")).toString());
    }
    else
    {
        QNetworkReply *reply = retry();
        if (reply)
        {
            connect(reply, &QNetworkReply::finished,
                    this, &GraftGenericAPI::receiveGetSeedResponse);
        }
    }
}

void GraftGenericAPI::receiveRestoreAccountResponse()
{
    mLastError.clear();
    qDebug() << "RestoreAccount Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    if (reply->error() != QNetworkReply::NoError)
    {
        mLastError = reply->errorString();
        reply->deleteLater();
        reply = nullptr;
    }
    else
    {
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
        QString viewKey;
        QString seed;
        QJsonObject response = QJsonDocument::fromJson(arr).object();
        if (response.contains(QLatin1String("result")))
        {
            QJsonObject object = response.value(QLatin1String("result")).toObject();
            address = object.value(QLatin1String("Address")).toString();
            seed = object.value(QLatin1String("Seed")).toString();
            viewKey = object.value(QLatin1String("ViewKey")).toString();
            if (accountArr.isEmpty() || address.isEmpty())
            {
                mLastError = QLatin1String("Couldn't get account data!");
            }
            else
            {
                mAccountData = accountArr;
                qDebug() << mAccountData << address << viewKey << seed;
                emit restoreAccountReceived(mAccountData, mPassword, address, viewKey, seed);
            }
        }
        else
        {
            mLastError = QLatin1String("Response error");
        }
    }
    if (!mLastError.isEmpty())
    {
        QNetworkReply *reply = retry();
        if (reply)
        {
            connect(reply, &QNetworkReply::finished,
                    this, &GraftGenericAPI::receiveRestoreAccountResponse);
        }
        else
        {
            emit restoreAccountReceived(mAccountData, mPassword, "", "", "");
        }
    }
}

void GraftGenericAPI::receiveTransferFeeResponse()
{
    mLastError.clear();
    qDebug() << "GetTransferFee Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        emit transferFeeReceived(object.value(QLatin1String("Result")).toInt(),
                                 object.value(QLatin1String("Fee")).toInt());
    }
    else
    {
        QNetworkReply *reply = retry();
        if (reply)
        {
            connect(reply, &QNetworkReply::finished,
                    this, &GraftGenericAPI::receiveTransferFeeResponse);
        }
    }
}

void GraftGenericAPI::receiveTransferResponse()
{
    mLastError.clear();
    qDebug() << "Transfer Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        emit transferReceived(object.value(QLatin1String("Result")).toInt());
    }
    else
    {
        QNetworkReply *reply = retry();
        if (reply)
        {
            connect(reply, &QNetworkReply::finished,
                    this, &GraftGenericAPI::receiveTransferResponse);
        }
    }
}
