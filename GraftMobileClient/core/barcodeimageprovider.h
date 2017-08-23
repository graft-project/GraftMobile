#ifndef BARCODEIMAGEPROVIDER_H
#define BARCODEIMAGEPROVIDER_H

#include <QQuickImageProvider>

class BarcodeImageProvider : public QQuickImageProvider
{
public:
    BarcodeImageProvider();

    void setBarcodeImage(const QString &id, const QImage &image);

    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize) override;

private:
    QMap<QString, QImage> mBarcodes;
};

#endif // BARCODEIMAGEPROVIDER_H
