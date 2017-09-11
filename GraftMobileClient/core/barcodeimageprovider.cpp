#include "barcodeimageprovider.h"

BarcodeImageProvider::BarcodeImageProvider()
    : QQuickImageProvider(QQuickImageProvider::Image)
{
}

void BarcodeImageProvider::setBarcodeImage(const QString &id, const QImage &image)
{
    mBarcodes.insert(id, image);
}

QImage BarcodeImageProvider::requestImage(const QString &id, QSize *size,
                                          const QSize &requestedSize)
{
    QImage image = mBarcodes.value(id);
    if (size)
    {
        *size = image.size();
    }
    if (!image.isNull())
    {
        return image.scaled(requestedSize.width() > 0 ? requestedSize.width() : image.width(),
                            requestedSize.height() > 0 ? requestedSize.height() : image.height(),
                            Qt::KeepAspectRatio);
    }
    return image;
}
