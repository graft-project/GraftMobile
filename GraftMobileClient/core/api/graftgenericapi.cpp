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

QJsonObject GraftGenericAPI::processReply()
{
    QJsonObject object;
    if (mReply->error() == QNetworkReply::NoError)
    {
        QByteArray rawData = mReply->readAll();
        if (!rawData.isEmpty())
        {
            object = QJsonDocument::fromJson(rawData).object();
            qDebug() << object.toVariantMap();
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
