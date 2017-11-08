#include "barcodeimageprovider.h"
#include "quickexchangemodel.h"
#include "graftbaseclient.h"
#include <QQmlEngine>

static const QString cBarcodeImageProviderID("barcodes");
static const QString cQRCodeImageID("qrcode");
static const QString cProviderScheme("image://%1/%2");

GraftBaseClient::GraftBaseClient(QObject *parent)
    : QObject(parent)
    ,mImageProvider(nullptr)
    ,mQuickExchangeModel(nullptr)
{
}

void GraftBaseClient::setQRCodeImage(const QImage &image)
{
    if (mImageProvider)
    {
        mImageProvider->setBarcodeImage(cQRCodeImageID, image);
    }
}

QString GraftBaseClient::qrCodeImage() const
{
    return cProviderScheme.arg(cBarcodeImageProviderID).arg(cQRCodeImageID);
}

void GraftBaseClient::registerImageProvider(QQmlEngine *engine)
{
    if (!mImageProvider)
    {
        mImageProvider = new BarcodeImageProvider();
        engine->addImageProvider(cBarcodeImageProviderID, mImageProvider);
    }
}

QuickExchangeModel *GraftBaseClient::quickExchangeModel()
{
    if (!mQuickExchangeModel)
    {
        mQuickExchangeModel = new QuickExchangeModel();
    }
    return mQuickExchangeModel;
}

void GraftBaseClient::setQuickExchangeModel(QuickExchangeModel *quickExchangeModel)
{
    if (quickExchangeModel)
    {
        mQuickExchangeModel = quickExchangeModel;
    }
}
