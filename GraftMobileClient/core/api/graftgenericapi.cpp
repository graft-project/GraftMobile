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
    QJsonObject object = QJsonDocument::fromJson(mReply->readAll()).object();
    qDebug() << object.toVariantMap();
    mReply->deleteLater();
    mReply = nullptr;
    return object;
}
