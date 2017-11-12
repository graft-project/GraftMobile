#include "barcodeimageprovider.h"
#include "quickexchangemodel.h"
#include "accountmodel.h"
#include "currencymodel.h"
#include "graftbaseclient.h"

#include <QQmlContext>

static const QString cBarcodeImageProviderID("barcodes");
static const QString cQRCodeImageID("qrcode");
static const QString cProviderScheme("image://%1/%2");

GraftBaseClient::GraftBaseClient(QObject *parent)
    : QObject(parent)
    ,mImageProvider(nullptr)
    ,mAccountModel(new AccountModel(this))
    ,mCurrencyModel(new CurrencyModel(this))
    ,mQuickExchangeModel(new QuickExchangeModel(this))
{
}

void GraftBaseClient::setQRCodeImage(const QImage &image)
{
    if (mImageProvider)
    {
        mImageProvider->setBarcodeImage(cQRCodeImageID, image);
    }
}

void GraftBaseClient::registeringTypes(QQmlEngine *engine)
{
    initAccountModel(engine);
    initCurrencyModel(engine);
    initQuickExchangeModel(engine);
#ifdef POS_BUILD
    registerImageProvider(engine);
#endif
}

QString GraftBaseClient::qrCodeImage() const
{
    return cProviderScheme.arg(cBarcodeImageProviderID).arg(cQRCodeImageID);
}

void GraftBaseClient::initAccountModel(QQmlEngine *engine)
{
    Q_ASSERT(mAccountModel);
    engine->rootContext()->setContextProperty(QStringLiteral("AccountModel"), mAccountModel);
}

void GraftBaseClient::initCurrencyModel(QQmlEngine *engine)
{
    Q_ASSERT(mCurrencyModel);
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

void GraftBaseClient::initQuickExchangeModel(QQmlEngine *engine)
{
    Q_ASSERT(mQuickExchangeModel);
    engine->rootContext()->setContextProperty(QStringLiteral("QuickExchangeModel"),
                                              mQuickExchangeModel);
}

void GraftBaseClient::registerImageProvider(QQmlEngine *engine)
{
    if (!mImageProvider)
    {
        mImageProvider = new BarcodeImageProvider();
        engine->addImageProvider(cBarcodeImageProviderID, mImageProvider);
    }
}
