#include "patrickqrcodeencoder.h"
#include <QNetworkAccessManager>
#include <QCoreApplication>
#include <QNetworkReply>
#include <QByteArray>
#include <QUrlQuery>
#include <QDebug>



PatrickQRCodeEncoder::PatrickQRCodeEncoder(QObject *parent)
    : QObject(parent), mUrl("https://www.patrick-wied.at/static/qrgen/qrgen.php"), manager(new QNetworkAccessManager(this))
{
}

PatrickQRCodeEncoder::~PatrickQRCodeEncoder()
{
    delete manager;
}

QImage PatrickQRCodeEncoder::encode(const QString &message)
{
    QUrlQuery query;
    query.addQueryItem("r", QString::number(19));
    query.addQueryItem("a", QString::number(0));
    query.addQueryItem("content", message);
    mUrl.setQuery(query);

    QNetworkRequest requestToQRCode(mUrl);

    QNetworkReply *reply = manager->get(requestToQRCode);

    while (!reply->isFinished())
    {
        QCoreApplication::processEvents();
    }

    QImage rImage;

    if (reply->error())
    {
        qDebug() << "\nError in reply: " << reply->errorString() << '\n';
    }
    else
    {
        QByteArray downloadedData = reply->readAll();
        rImage = QImage::fromData(downloadedData);
    }

    reply->deleteLater();

    return rImage;
}
