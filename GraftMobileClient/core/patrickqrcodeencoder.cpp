#include "patrickqrcodeencoder.h"
#include <QUrlQuery>
#include <QDebug>

PatrickQRCodeEncoder::PatrickQRCodeEncoder()
{
}

PatrickQRCodeEncoder::PatrickQRCodeEncoder(const QString &_url) : mUrl(_url)
{
}

void PatrickQRCodeEncoder::setUrl(const QString &request)
{

    QUrl link = mUrl;

    QUrlQuery Query;
    Query.addQueryItem("r", QString::number(19));
    Query.addQueryItem("a", QString::number(0));
    Query.addQueryItem("content", request);
    link.setQuery(Query);

    qDebug() << link.toEncoded() << '\n';
}
