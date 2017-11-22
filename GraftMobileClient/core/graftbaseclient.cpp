#include "accountmodelserializator.h"
#include "barcodeimageprovider.h"
#include "api/graftgenericapi.h"
#include "quickexchangemodel.h"
#include "graftbaseclient.h"
#include "accountmanager.h"
#include "currencymodel.h"
#include "currencyitem.h"
#include "accountmodel.h"
#include "config.h"

#include <QStandardPaths>
#include <QHostAddress>
#include <QQmlContext>
#include <QTimerEvent>
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
    ,mBalanceTimer(-1)
    ,mAccountManager(new AccountManager())
{
    initSettings();
}

GraftBaseClient::~GraftBaseClient()
{
    delete mAccountManager;
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

void GraftBaseClient::timerEvent(QTimerEvent *event)
{
    if (event->timerId() == mBalanceTimer)
    {
        updateBalance();
    }
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

void GraftBaseClient::requestAccount(GraftGenericAPI *api)
{
    if (mAccountManager->account().isEmpty() && api)
    {
        connect(api, &GraftGenericAPI::createAccountReceived,
                this, &GraftBaseClient::receiveAccount);
        api->createAccount(mAccountManager->passsword());
    }
}

void GraftBaseClient::registerBalanceTimer(GraftGenericAPI *api)
{
    if (api)
    {
        connect(api, &GraftGenericAPI::getBalanceReceived, this, &GraftBaseClient::receiveBalance);
        mBalanceTimer = startTimer(20000);
    }
}

void GraftBaseClient::receiveAccount(const QByteArray &accountData, const QString &password)
{
    if (mAccountManager->passsword() == password && !accountData.isEmpty())
    {
        mAccountManager->setAccount(accountData);
    }
}

void GraftBaseClient::receiveBalance(double balance, double unlockedBalance)
{
    if (balance >= 0 && unlockedBalance >= 0)
    {
        mBalances.insert(LockedBalance, balance);
        mBalances.insert(UnlockedBalance, unlockedBalance);
        mBalances.insert(LocalBalance, unlockedBalance);
        emit balanceUpdated();
    }
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
        mCurrencyModel->add(QStringLiteral("BITCOIN"),
                            QStringLiteral("BTC"), QStringLiteral("qrc:/coins/btc.png"));
        mCurrencyModel->add(QStringLiteral("BITCONNECT COIN"),
                            QStringLiteral("BCC"), QStringLiteral("qrc:/coins/bcc.png"));
        mCurrencyModel->add(QStringLiteral("DASH"),
                            QStringLiteral("DASH"), QStringLiteral("qrc:/coins/dash.png"));
        mCurrencyModel->add(QStringLiteral("ETHER"),
                            QStringLiteral("ETH"), QStringLiteral("qrc:/coins/eth.png"));
        mCurrencyModel->add(QStringLiteral("LITECOIN"),
                            QStringLiteral("LTC"), QStringLiteral("qrc:/coins/ltc.png"));
        mCurrencyModel->add(QStringLiteral("NEW ECONOMY MOVEMENT"),
                            QStringLiteral("NEM"), QStringLiteral("qrc:/coins/nem.png"));
        mCurrencyModel->add(QStringLiteral("NEO"),
                            QStringLiteral("NEO"), QStringLiteral("qrc:/coins/neo.png"));
        mCurrencyModel->add(QStringLiteral("RIPPLE"),
                            QStringLiteral("XRP"), QStringLiteral("qrc:/coins/xrp.png"));
        mCurrencyModel->add(QStringLiteral("MONERO"),
                            QStringLiteral("XMR"), QStringLiteral("qrc:/coins/xmr.png"));
        engine->rootContext()->setContextProperty(QStringLiteral("CoinModel"), mCurrencyModel);
    }
}

void GraftBaseClient::initQuickExchangeModel(QQmlEngine *engine)
{
    if(!mQuickExchangeModel)
    {
        mQuickExchangeModel = new QuickExchangeModel(this);
        mQuickExchangeModel->add(QStringLiteral("US Dollar"), QStringLiteral("USD"),
                                 QString(), true);
        for (CurrencyItem *item : mCurrencyModel->currencies())
        {
            mQuickExchangeModel->add(item->name(), item->code());
        }
        engine->rootContext()->setContextProperty(QStringLiteral("QuickExchangeModel"),
                                                  mQuickExchangeModel);
    }
}

void GraftBaseClient::setSettings(const QString &key, const QVariant &value)
{
    mClientSettings->setValue(key, value);
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

double GraftBaseClient::balance(GraftBaseClient::BalanceTypes type) const
{
    return mBalances.value(type, 0);
}

void GraftBaseClient::updateQuickExchange(double cost)
{
    QStringList codes = mQuickExchangeModel->codeList();
    for (int i = 0; i < codes.count(); ++i)
    {
        double course = 1.0;
        if (codes.value(i) != QLatin1String("USD"))
        {
            course = (double)qrand() / RAND_MAX;
        }
        mQuickExchangeModel->updatePrice(codes.value(i), QString::number(course * cost));
    }
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
