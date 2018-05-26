#ifndef QRCODEGENERATOR_H
#define QRCODEGENERATOR_H

#include <QString>
#include <QImage>

class QRCodeGenerator
{
public:
    static QImage encode(const QString &message);
};

#endif // QRCODEGENERATOR_H
