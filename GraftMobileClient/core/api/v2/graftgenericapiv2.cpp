#include "graftgenericapiv2.h"
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include "../../config.h"

GraftGenericAPIv2::GraftGenericAPIv2(const QStringList &addresses, const QString &dapiVersion,
                                     QObject *parent)
    : QObject(parent)
    ,mDAPIVersion(dapiVersion)
{
    mRetries = 0;
    mCurrentAddress = -1;
    mAddresses = addresses;
    mManager = nullptr;
    mRequest = QNetworkRequest(nextAddress());
    mRequest.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
}

GraftGenericAPIv2::~GraftGenericAPIv2()
{
}

void GraftGenericAPIv2::changeAddresses(const QStringList &addresses)
{
    mAddresses = addresses;
    mCurrentAddress = -1;
    mRequest.setUrl(nextAddress());
}

void GraftGenericAPIv2::setDAPIVersion(const QString &version)
{
    mDAPIVersion = version;
}

void GraftGenericAPIv2::setAccountData(const QByteArray &accountData, const QString &password)
{
    mAccountData = accountData;
    mPassword = password;
}

QByteArray GraftGenericAPIv2::accountData() const
{
    return mAccountData;
}

QString GraftGenericAPIv2::password() const
{
    return mPassword;
}

double GraftGenericAPIv2::toCoins(double atomic)
{
    return (1.0 * atomic) / 10000000000.0;
}

double GraftGenericAPIv2::toCoins(uint64_t atomic)
{
    return (1.0 * atomic) / 10000000000.0;
}

double GraftGenericAPIv2::toAtomic(double coins)
{
    return coins * 10000000000;
}

uint64_t GraftGenericAPIv2::toAtomic(const QString &coins)
{
    return static_cast<uint64_t>(coins.toDouble() * 10000000000);
}

void GraftGenericAPIv2::setNetworkManager(QNetworkAccessManager *networkManager)
{
    if (networkManager && mManager != networkManager)
    {
        mManager = networkManager;
    }
}

QString GraftGenericAPIv2::accountPlaceholder() const
{
    return QString("????");
}

QByteArray GraftGenericAPIv2::serializeAmount(double amount) const
{
    QByteArray serializedAmount;
    serializedAmount.setNum(toAtomic(amount), 'f', 0);
    return serializedAmount;
}

QJsonObject GraftGenericAPIv2::buildMessage(const QString &key, const QJsonObject &params) const
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

QJsonObject GraftGenericAPIv2::processReply(QNetworkReply *reply)
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

QUrl GraftGenericAPIv2::nextAddress(const QString &endpoint)
{
    mCurrentAddress++;
    if (mCurrentAddress >= mAddresses.count())
    {
        mCurrentAddress = 0;
    }
    if (endpoint.isEmpty())
    {
        return QUrl(scUrl.arg(mAddresses.value(mCurrentAddress)));
    }
    else
    {
        return QUrl(scDapiUrl.arg(mAddresses.value(mCurrentAddress)).arg(endpoint));
    }
}

QNetworkReply *GraftGenericAPIv2::retry()
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
