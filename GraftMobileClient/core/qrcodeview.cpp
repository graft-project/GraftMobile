#include "qrcodeview.h"
#include "graftbaseclient.h"
#include <QPainter>

QRCodeView::QRCodeView(QQuickItem *parent)
    : QQuickPaintedItem(parent)
    ,mClient(nullptr)
{
}

void QRCodeView::paint(QPainter *painter)
{
    if (mClient)
    {
        painter->drawImage(QRectF(0, 0, width(), height()), mClient->qrCodeImage());
    }
}

void QRCodeView::setClient(GraftBaseClient *client)
{
    mClient = client;
    connect(mClient, &GraftBaseClient::updateQRCode, this, &QRCodeView::updateQRImage);
}

GraftBaseClient *QRCodeView::client() const
{
    return mClient;
}

void QRCodeView::updateQRImage()
{
    update();
}
