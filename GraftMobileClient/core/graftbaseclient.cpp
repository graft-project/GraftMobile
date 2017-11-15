#include "barcodeimageprovider.h"
#include "quickexchangemodel.h"
#include "graftbaseclient.h"
#include "currencymodel.h"
#include "accountmodel.h"
#include "config.h"

#include <QStandardPaths>
#include <QHostAddress>
#include <QQmlContext>
#include <QQmlEngine>
#include <QSettings>
#include <QFileInfo>
#include <QDir>


static const QString cBarcodeImageProviderID("barcodes");
static const QString cQRCodeImageID("qrcode");
static const QString cProviderScheme("image://%1/%2");
static const QString scSettingsDataFile("Settings.ini");

GraftBaseClient::GraftBaseClient(QObject *parent)
    : QObject(parent)
    ,mImageProvider(nullptr)
    ,mClientSettings(nullptr)
    ,mAccountModel(nullptr)
    ,mCurrencyModel(nullptr)
    ,mQuickExchangeModel(nullptr)
{
        initSettings();
}

AccountModel *GraftBaseClient::accountModel() const
{
    return mAccountModel;
}

CurrencyModel *GraftBaseClient::currencyModel() const
{
    return mCurrencyModel;
}

QuickExchangeModel *GraftBaseClient::quickExchangeModel() const
{
    return mQuickExchangeModel;
}

void GraftBaseClient::setQRCodeImage(const QImage &image)
{
    if (mImageProvider)
    {
        mImageProvider->setBarcodeImage(cQRCodeImageID, image);
    }
}

void GraftBaseClient::registerTypes(QQmlEngine *engine)
{
    initAccountModel(engine);
    initCurrencyModel(engine);
    initQuickExchangeModel(engine);
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

QUrl GraftBaseClient::getServiceUrl() const
{
    QString finalUrl;
    if (useOwnServiceAddress())
    {
        QString ip(settings("ip").toString());
        QString port(settings("port").toString());
        finalUrl = QString("%1:%2").arg(ip).arg(port);
    }
    else
    {
        finalUrl = cSeedSupernodes.value(qrand() % cSeedSupernodes.count());
    }
    return QUrl(cUrl.arg(finalUrl));
}

void GraftBaseClient::initAccountModel(QQmlEngine *engine)
{
    if(!mAccountModel)
    {
        mAccountModel = new AccountModel(this);
        engine->rootContext()->setContextProperty(QStringLiteral("AccountModel"), mAccountModel);
    }
}

void GraftBaseClient::initCurrencyModel(QQmlEngine *engine)
{
    if(!mCurrencyModel)
    {
        mCurrencyModel = new CurrencyModel(this);
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
}

void GraftBaseClient::initQuickExchangeModel(QQmlEngine *engine)
{
    if(!mQuickExchangeModel)
    {
        mQuickExchangeModel = new QuickExchangeModel(this);
        engine->rootContext()->setContextProperty(QStringLiteral("QuickExchangeModel"),
                                                  mQuickExchangeModel);
    }
}

void GraftBaseClient::setSettings(const QString &key, const QVariant &value)
{
    mClientSettings->setValue(key,value);
}

bool GraftBaseClient::useOwnServiceAddress() const
{
    return mClientSettings->value(QStringLiteral("useOwnServiceAddress")).toBool();
}

bool GraftBaseClient::resetUrl(const QString &ip, const QString &port)
{
    bool lIsResetUrl = (useOwnServiceAddress() && isValidIp(ip) && !ip.isEmpty());
    if (lIsResetUrl)
    {
        setSettings(QStringLiteral("ip"), ip);
        setSettings(QStringLiteral("port"), port);
    }
    return lIsResetUrl;
}

bool GraftBaseClient::isValidIp(const QString &ip) const
{
    QHostAddress validateIp;
    return validateIp.setAddress(ip);
}

QVariant GraftBaseClient::settings(const QString &key) const
{
    return mClientSettings->value(key);
}

void GraftBaseClient::saveSettings() const
{
    mClientSettings->sync();
}

void GraftBaseClient::initSettings()
{
    QString dataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    if (!QFileInfo(dataPath).exists())
    {
        QDir().mkpath(dataPath);
    }
    QDir lDir(dataPath);
    mClientSettings = new QSettings(lDir.filePath(scSettingsDataFile), QSettings::IniFormat, this);
}
