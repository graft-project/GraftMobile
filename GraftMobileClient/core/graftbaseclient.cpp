#include "barcodeimageprovider.h"
#include "quickexchangemodel.h"
#include "graftbaseclient.h"
#include "accountmodel.h"
#include "currencymodel.h"

#include <QQmlContext>

static const QString cBarcodeImageProviderID("barcodes");
static const QString cQRCodeImageID("qrcode");
static const QString cProviderScheme("image://%1/%2");

GraftBaseClient::GraftBaseClient(QQmlEngine *engine, QObject *parent)
    : QObject(parent)
    ,mImageProvider(nullptr)
    ,mQuickExchangeModel(new QuickExchangeModel(this))
    ,mAccountModel(nullptr)
    ,mCurrencyModel(nullptr)
{
    initAccountModel(engine);
    initCurrencyModel(engine);
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

QuickExchangeModel *GraftBaseClient::quickExchangeModel() const
{
    return mQuickExchangeModel;
}

void GraftBaseClient::registerImageProvider(QQmlEngine *engine)
{
    if (!mImageProvider)
    {
        mImageProvider = new BarcodeImageProvider();
        engine->addImageProvider(cBarcodeImageProviderID, mImageProvider);
    }
}

void GraftBaseClient::initAccountModel(QQmlEngine *engine)
{
    mAccountModel = new AccountModel();
    engine->rootContext()->setContextProperty(QStringLiteral("AccountModel"), mAccountModel);
}

void GraftBaseClient::initCurrencyModel(QQmlEngine *engine)
{
    mCurrencyModel = new CurrencyModel();
    mCurrencyModel->add(QStringLiteral("BITCONNECT COIN"), QStringLiteral("qrc:/imgs/coins/bcc.png"));
    mCurrencyModel->add(QStringLiteral("BITCOIN"), QStringLiteral("qrc:/imgs/coins/bitcoin.png"));
    mCurrencyModel->add(QStringLiteral("DASH"), QStringLiteral("qrc:/imgs/coins/dash.png"));
    mCurrencyModel->add(QStringLiteral("ETHER"), QStringLiteral("qrc:/imgs/coins/ether.png"));
    mCurrencyModel->add(QStringLiteral("LITECOIN"), QStringLiteral("qrc:/imgs/coins/litecoin.png"));
    mCurrencyModel->add(QStringLiteral("MONERO"), QStringLiteral("qrc:/imgs/coins/monero.png"));
    mCurrencyModel->add(QStringLiteral("NEW ECONOMY MOVEMENT"), QStringLiteral("qrc:/imgs/coins/nem.png"));
    mCurrencyModel->add(QStringLiteral("NEO"), QStringLiteral("qrc:/imgs/coins/neo.png"));
    mCurrencyModel->add(QStringLiteral("RIPPLE"), QStringLiteral("qrc:/imgs/coins/ripple.png"));
    engine->rootContext()->setContextProperty(QStringLiteral("CoinModel"), mCurrencyModel);
}
