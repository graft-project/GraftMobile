#include "patrickqrcodeencoder.h"
#include <QNetworkAccessManager>
#include <QCoreApplication>
#include <QNetworkReply>
#include <QByteArray>
#include <QUrlQuery>
#include <QDebug>

static const QString scUrl = "https://www.patrick-wied.at/static/qrgen/qrgen.php";

PatrickQRCodeEncoder::PatrickQRCodeEncoder(QObject *parent)
    : QObject(parent), mUrl(scUrl), mManager(new QNetworkAccessManager(this))
{
}

QImage PatrickQRCodeEncoder::encode(const QString &cMessage)
{
    QUrlQuery query;
    query.addQueryItem("r", QString::number(19));
    query.addQueryItem("a", QString::number(0));
    query.addQueryItem("content", cMessage);
    mUrl.setQuery(query);

    QNetworkRequest requestToQRCode(mUrl);

    QNetworkReply *reply = mManager->get(requestToQRCode);

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
