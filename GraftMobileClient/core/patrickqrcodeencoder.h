#ifndef PATRICKQRCODEENCODER_H
#define PATRICKQRCODEENCODER_H

#include <QObject>
#include <QImage>
#include <QUrl>

class QNetworkAccessManager;

class PatrickQRCodeEncoder
{
public:
    PatrickQRCodeEncoder();
    ~PatrickQRCodeEncoder();
    QImage encode(const QString &message);

private:
    QUrl mUrl;
    QNetworkAccessManager *mManager;
};

#endif // PATRICKQRCODEENCODER_H
