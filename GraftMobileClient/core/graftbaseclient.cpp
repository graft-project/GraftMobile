#include "graftbaseclient.h"

GraftBaseClient::GraftBaseClient(QObject *parent)
    : QObject(parent)
{
}

void GraftBaseClient::setQRCodeImage(const QImage &image)
{
    mQRCodeImage = image;
    emit updateQRCode();
}

QImage GraftBaseClient::qrCodeImage() const
{
    return mQRCodeImage;
}
