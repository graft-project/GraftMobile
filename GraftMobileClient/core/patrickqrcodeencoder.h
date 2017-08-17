#ifndef PATRICKQRCODEENCODER_H
#define PATRICKQRCODEENCODER_H

#include <QUrl>

class PatrickQRCodeEncoder
{
public:
    PatrickQRCodeEncoder();
    PatrickQRCodeEncoder(const QString&);
    void setUrl(const QString&);

private:
    const QUrl mUrl;
};

#endif // PATRICKQRCODEENCODER_H
