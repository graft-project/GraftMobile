#include "qrcodegenerator.h"
#include "QrCoder.hpp"
#include <QImage>
#include <QDebug>

QRCodeGenerator::QRCodeGenerator()
{
}

QImage QRCodeGenerator::encode(const QString &message)
{
    qrcodegen::QrCoder qrcode = qrcodegen::QrCoder::encodeText(message.toStdString().c_str(), qrcodegen::QrCoder::Ecc::QUARTILE);
    QImage img = QImage::fromData(QByteArray::fromStdString(qrcode.toSvgString(2)));
    return img.scaled(300, 300);
}
