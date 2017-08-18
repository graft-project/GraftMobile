#ifndef PATRICKQRCODEENCODER_H
#define PATRICKQRCODEENCODER_H

#include <QObject>
#include <QImage>
#include <QUrl>

class QNetworkAccessManager;

class PatrickQRCodeEncoder : public QObject
{
    Q_OBJECT
public:
    PatrickQRCodeEncoder(QObject *parent = nullptr);
    QImage encode(const QString &cMessage);

private:
    QUrl mUrl;
    QNetworkAccessManager *mManager;
};

#endif // PATRICKQRCODEENCODER_H
