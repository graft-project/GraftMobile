#include "barcodeimageprovider.h"
#include "quickexchangemodel.h"
#include "accountmodel.h"
#include "currencymodel.h"
#include "graftbaseclient.h"
#include "accountmodelserializator.h"

#include <QStandardPaths>
#include <QQmlContext>
#include <QQmlEngine>
#include <QSettings>
#include <QFileInfo>
#include <QDir>

static const QString cBarcodeImageProviderID("barcodes");
static const QString cQRCodeImageID("qrcode");
static const QString cProviderScheme("image://%1/%2");
static const QString scAccountModelDataFile("accountList.dat");
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

void GraftBaseClient::saveAccounts() const
{
    saveModel(scAccountModelDataFile, AccountModelSerializator::serialize(mAccountModel));
}

void GraftBaseClient::registerImageProvider(QQmlEngine *engine)
{
    if (!mImageProvider)
    {
        mImageProvider = new BarcodeImageProvider();
        engine->addImageProvider(cBarcodeImageProviderID, mImageProvider);
    }
}

void GraftBaseClient::saveModel(const QString &fileName, const QByteArray &data) const
{
    QString dataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    if (!QFileInfo(dataPath).exists())
    {
        QDir().mkpath(dataPath);
    }
    QDir lDir(dataPath);
    QFile lFile(lDir.filePath(fileName));
    if (lFile.open(QFile::WriteOnly))
    {
        lFile.write(data);
        lFile.close();
    }
}

QByteArray GraftBaseClient::loadModel(const QString &fileName) const
{
    QString dataPath = QStandardPaths::locate(QStandardPaths::AppDataLocation,
                                              fileName);
    if (!dataPath.isEmpty())
    {
        QFile lFile(dataPath);
        if (lFile.open(QFile::ReadOnly))
        {
            return lFile.readAll();
        }
    }
    return QByteArray();
}

void GraftBaseClient::initAccountModel(QQmlEngine *engine)
{
    if(!mAccountModel)
    {
        mAccountModel = new AccountModel(this);
        engine->rootContext()->setContextProperty(QStringLiteral("AccountModel"), mAccountModel);
        AccountModelSerializator::deserialize(loadModel(scAccountModelDataFile), mAccountModel);
    }
}

void GraftBaseClient::initCurrencyModel(QQmlEngine *engine)
{
    if(!mCurrencyModel)
    {
        mCurrencyModel = new CurrencyModel(this);
        mCurrencyModel->add(QStringLiteral("BITCONNECT COIN"),
                            QStringLiteral("BCC"), QStringLiteral("qrc:/imgs/coins/bcc.png"));
        mCurrencyModel->add(QStringLiteral("BITCOIN"),
                            QStringLiteral("BTC"), QStringLiteral("qrc:/imgs/coins/bitcoin.png"));
        mCurrencyModel->add(QStringLiteral("DASH"),
                            QStringLiteral("DASH"), QStringLiteral("qrc:/imgs/coins/dash.png"));
        mCurrencyModel->add(QStringLiteral("ETHER"),
                            QStringLiteral("ETH"), QStringLiteral("qrc:/imgs/coins/ether.png"));
        mCurrencyModel->add(QStringLiteral("LITECOIN"),
                            QStringLiteral("LTC"), QStringLiteral("qrc:/imgs/coins/litecoin.png"));
        mCurrencyModel->add(QStringLiteral("MONERO"),
                            QStringLiteral("XMR"), QStringLiteral("qrc:/imgs/coins/monero.png"));
        mCurrencyModel->add(QStringLiteral("NEW ECONOMY MOVEMENT"),
                            QStringLiteral("NEM"), QStringLiteral("qrc:/imgs/coins/nem.png"));
        mCurrencyModel->add(QStringLiteral("NEO"),
                            QStringLiteral("NEO"), QStringLiteral("qrc:/imgs/coins/neo.png"));
        mCurrencyModel->add(QStringLiteral("RIPPLE"),
                            QStringLiteral("XRP"), QStringLiteral("qrc:/imgs/coins/ripple.png"));
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
    mClientSettings->setValue(key, value);
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
