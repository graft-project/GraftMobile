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

QJsonObject GraftGenericAPI::processReply()
{
    if (mReply->error() == QNetworkReply::NoError)
    {
        QByteArray rawData = mReply->readAll();
        mReply->deleteLater();
        mReply = nullptr;
        if (!rawData.isEmpty())
        {
            QJsonObject object = QJsonDocument::fromJson(rawData).object();
            qDebug() << object.toVariantMap();
            if (object.isEmpty())
            {
                emit error();
            }
            return object;
        }
        emit error();
    }
    return QJsonObject();
}
