#include "graftgenericapiv1.h"
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include "../../config.h"

GraftGenericAPIv1::GraftGenericAPIv1(const QStringList &addresses, const QString &dapiVersion,
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

GraftGenericAPIv1::~GraftGenericAPIv1()
{
}

void GraftGenericAPIv1::changeAddresses(const QStringList &addresses)
{
    mAddresses = addresses;
    mCurrentAddress = -1;
    mRequest.setUrl(nextAddress());
}

void GraftGenericAPIv1::setDAPIVersion(const QString &version)
{
    mDAPIVersion = version;
}

void GraftGenericAPIv1::setAccountData(const QByteArray &accountData, const QString &password)
{
    mAccountData = accountData;
    mPassword = password;
}

QByteArray GraftGenericAPIv1::accountData() const
{
    return mAccountData;
}

QString GraftGenericAPIv1::password() const
{
    return mPassword;
}

void GraftGenericAPIv1::createAccount(const QString &password)
{
    mRetries = 0;
    mPassword = password;
    QJsonObject params;
    params.insert(QStringLiteral("Language"), QStringLiteral("English"));
    QJsonObject data = buildMessage(QStringLiteral("CreateAccount"), params);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished,
            this, &GraftGenericAPIv1::receiveCreateAccountResponse);
}

void GraftGenericAPIv1::getBalance()
{
    mRetries = 0;
    if (mAccountData.isEmpty())
    {
        qDebug() << "GraftGenericAPI: Account Data is empty.";
        emit error(QStringLiteral("Couldn't find account data."));
        return;
    }
    QJsonObject params;
    params.insert(QStringLiteral("Account"), accountPlaceholder());
    QJsonObject data = buildMessage(QStringLiteral("GetWalletBalance"), params);
    QByteArray array = QJsonDocument(data).toJson();
    array.replace(accountPlaceholder(), mAccountData);
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftGenericAPIv1::receiveGetBalanceResponse);
}

void GraftGenericAPIv1::getSeed()
{
    mRetries = 0;
    if (mAccountData.isEmpty())
    {
        qDebug() << "GraftGenericAPI: Account Data is empty.";
        emit error(QStringLiteral("Couldn't find account data."));
        return;
    }
    QJsonObject params;
    params.insert(QStringLiteral("Account"), accountPlaceholder());
    params.insert(QStringLiteral("Language"), QStringLiteral("English"));
    QJsonObject data = buildMessage(QStringLiteral("GetSeed"), params);
    QByteArray array = QJsonDocument(data).toJson();
    array.replace(accountPlaceholder(), mAccountData);
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftGenericAPIv1::receiveGetSeedResponse);
}

void GraftGenericAPIv1::restoreAccount(const QString &seed, const QString &password)
{
    mRetries = 0;
    mPassword = password;
    QJsonObject params;
    params.insert(QStringLiteral("Seed"), seed);
    QJsonObject data = buildMessage(QStringLiteral("RestoreAccount"), params);
    QByteArray array = QJsonDocument(data).toJson();
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished,
            this, &GraftGenericAPIv1::receiveRestoreAccountResponse);
}

void GraftGenericAPIv1::transferFee(const QString &address, const QString &amount,
                                    const QString &paymentID)
{
    mRetries = 0;
    if (mAccountData.isEmpty())
    {
        qDebug() << "GraftGenericAPI: Account Data is empty.";
        emit error(QStringLiteral("Couldn't find account data."));
        return;
    }
    QJsonObject params;
    params.insert(QStringLiteral("Account"), accountPlaceholder());
    params.insert(QStringLiteral("Address"), address);
    params.insert(QStringLiteral("PaymentID"), paymentID);
    params.insert(QStringLiteral("Amount"), amount);
    QJsonObject data = buildMessage(QStringLiteral("GetTransferFee"), params);
    QByteArray array = QJsonDocument(data).toJson();
    array.replace(accountPlaceholder(), mAccountData);
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftGenericAPIv1::receiveTransferFeeResponse);
}

void GraftGenericAPIv1::transfer(const QString &address, const QString &amount,
                                 const QString &paymentID)
{
    mRetries = 0;
    if (mAccountData.isEmpty())
    {
        qDebug() << "GraftGenericAPI: Account Data is empty.";
        emit error(QStringLiteral("Couldn't find account data."));
        return;
    }
    QJsonObject params;
    params.insert(QStringLiteral("Account"), accountPlaceholder());
    params.insert(QStringLiteral("Address"), address);
    params.insert(QStringLiteral("PaymentID"), paymentID);
    params.insert(QStringLiteral("Amount"), amount);
    QJsonObject data = buildMessage(QStringLiteral("Transfer"), params);
    QByteArray array = QJsonDocument(data).toJson();
    array.replace(accountPlaceholder(), mAccountData);
    mTimer.start();
    mLastRequest = array;
    QNetworkReply *reply = mManager->post(mRequest, array);
    connect(reply, &QNetworkReply::finished, this, &GraftGenericAPIv1::receiveTransferResponse);
}

double GraftGenericAPIv1::toCoins(double atomic)
{
    return (1.0 * atomic) / 10000000000.0;
}

double GraftGenericAPIv1::toAtomic(double coins)
{
    return coins * 10000000000;
}

QNetworkAccessManager *GraftGenericAPIv1::networkManager() const
{
    return mManager;
}

QString GraftGenericAPIv1::accountPlaceholder() const
{
    return QString("????");
}

QByteArray GraftGenericAPIv1::serializeAmount(double amount) const
{
    QByteArray serializedAmount;
    serializedAmount.setNum(toAtomic(amount), 'f', 0);
    return serializedAmount;
}

QJsonObject GraftGenericAPIv1::buildMessage(const QString &key, const QJsonObject &params) const
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

QJsonObject GraftGenericAPIv1::processReply(QNetworkReply *reply)
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

QUrl GraftGenericAPIv1::nextAddress()
{
    mCurrentAddress++;
    if (mCurrentAddress >= mAddresses.count())
    {
        mCurrentAddress = 0;
    }
    return QUrl(scUrl.arg(mAddresses.value(mCurrentAddress)));
}

QNetworkReply *GraftGenericAPIv1::retry()
{
    if (mRetries < mAddresses.count() - 1)
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

void GraftGenericAPIv1::receiveCreateAccountResponse()
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
                    this, &GraftGenericAPIv1::receiveCreateAccountResponse);
        }
        else
        {
            emit createAccountReceived(mAccountData, mPassword, "", "", "");
        }
    }
}

void GraftGenericAPIv1::receiveGetBalanceResponse()
{
    mLastError.clear();
    qDebug() << "GetBalance Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        emit balanceReceived(toCoins(object.value(QLatin1String("Balance")).toDouble()),
                             toCoins(object.value(QLatin1String("UnlockedBalance")).toDouble()));
    }
    else
    {
        mRequest.setUrl(nextAddress());
        getBalance();
    }
}

void GraftGenericAPIv1::receiveGetSeedResponse()
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
                    this, &GraftGenericAPIv1::receiveGetSeedResponse);
        }
    }
}

void GraftGenericAPIv1::receiveRestoreAccountResponse()
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
                    this, &GraftGenericAPIv1::receiveRestoreAccountResponse);
        }
        else
        {
            emit restoreAccountReceived(mAccountData, mPassword, "", "", "");
        }
    }
}

void GraftGenericAPIv1::receiveTransferFeeResponse()
{
    mLastError.clear();
    qDebug() << "GetTransferFee Response Received:\nTime: " << mTimer.elapsed();
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QJsonObject object = processReply(reply);
    if (!object.isEmpty())
    {
        emit transferFeeReceived(object.value(QLatin1String("Result")).toInt(),
                                 object.value(QLatin1String("Fee")).toDouble());
    }
    else
    {
        QNetworkReply *reply = retry();
        if (reply)
        {
            connect(reply, &QNetworkReply::finished,
                    this, &GraftGenericAPIv1::receiveTransferFeeResponse);
        }
    }
}

void GraftGenericAPIv1::receiveTransferResponse()
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
                    this, &GraftGenericAPIv1::receiveTransferResponse);
        }
    }
}
