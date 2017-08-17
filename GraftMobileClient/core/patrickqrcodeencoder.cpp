#include "patrickqrcodeencoder.h"
#include <QNetworkAccessManager>
#include <QCoreApplication>
#include <QNetworkReply>
#include <QByteArray>
#include <QUrlQuery>
#include <QImage>
#include <QDebug>

QImage PatrickQRCodeEncoder::encode(const QString &message) const
{
    QUrl link = mUrl;

    QUrlQuery query;
    query.addQueryItem("r", QString::number(19));
    query.addQueryItem("a", QString::number(0));
    query.addQueryItem("content", message);
    link.setQuery(query);

    QNetworkAccessManager *manager = new QNetworkAccessManager;

    QNetworkRequest requestToQRCode(link);

    QNetworkReply *reply = manager->get(requestToQRCode);

    while (!reply->isFinished())
    {
        QCoreApplication::processEvents();
    }

    if (reply->error())
    {
        qDebug() << "\nError in reply: " << reply->errorString() << '\n';
    }
    else
    {
        QByteArray downloadedData = reply->readAll();
        qDebug() << '\n' << downloadedData << '\n';
        return QImage::fromData(downloadedData);
    }

    return QImage();
}
