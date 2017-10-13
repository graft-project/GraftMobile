#include "qrcodegenerator.h"
#include "QrCode.hpp"
#include <QImage>
#include <QDebug>

QRCodeGenerator::QRCodeGenerator()
{
}

QImage QRCodeGenerator::encode(const QString &message)
{
    qrcodegen::QrCode qrcode = qrcodegen::QrCode::encodeText(message.toStdString().c_str(), qrcodegen::QrCode::Ecc::QUARTILE);
    QImage img = QImage::fromData(QByteArray::fromStdString(qrcode.toSvgString(2)));
    return img.scaled(300, 300);
}
