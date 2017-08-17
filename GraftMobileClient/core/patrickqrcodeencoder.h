#ifndef PATRICKQRCODEENCODER_H
#define PATRICKQRCODEENCODER_H

#include <QUrl>
#include <QImage>

class PatrickQRCodeEncoder
{
public:
    PatrickQRCodeEncoder(const QString &_url = "https://www.patrick-wied.at/static/qrgen/qrgen.php") : mUrl(_url) {}
    QImage encode(const QString&) const;

private:
    const QUrl mUrl;
};

#endif // PATRICKQRCODEENCODER_H
