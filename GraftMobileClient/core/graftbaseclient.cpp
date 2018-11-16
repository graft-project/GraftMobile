#include "accountmodelserializator.h"
#include "barcodeimageprovider.h"
#include "api/graftbasehandler.h"
#include "api/v1/graftgenericapiv1.h"
#include "quickexchangemodel.h"
#include "graftclienttools.h"
#include "graftbaseclient.h"
#include "qrcodegenerator.h"
#include "accountmanager.h"
#include "currencymodel.h"
#include "currencyitem.h"
#include "accountmodel.h"
#include "config.h"

#include <QRegularExpression>
#include <QGuiApplication>
#include <QStandardPaths>
#include <QVersionNumber>
#include <QHostAddress>
#include <QQmlContext>
#include <QTimerEvent>
#include <QClipboard>
#include <QQmlEngine>
#include <QSettings>
#include <QFileInfo>
#include <QTimer>
#include <QDir>

static const QVersionNumber scVersionNumber(MAJOR_VERSION, MINOR_VERSION, BUILD_VERSION);
static const QString scCoinAddressQRCodeImageID("coin_address_qrcode");
static const QString scUseOwnServiceAddress("useOwnServiceAddress");
static const QString scAccountModelDataFile("accountList.dat");
static const QString scAddressQRCodeImageID("address_qrcode");
static const QString scUseOwnUrlAddress("useOwnUrlAddress");
static const QString scUnlockedBalancee("unlockedBalance");
static const QString scBarcodeImageProviderID("barcodes");
static const QString scSettingsDataFile("Settings.ini");
static const QString scProviderScheme("image://%1/%2");
static const QString scLockedBalance("lockedBalance");
static const QString scLocalBalance("localBalance");
static const QString scNetworkType("httpsType");
static const QString scQRCodeImageID("qrcode");
static const QString scLicense("license");
static const QString scAddress("address");
static const QString scPort("port");
static const QString scIp("ip");

GraftBaseClient::GraftBaseClient(QObject *parent)
    : QObject(parent)
    ,mQuickExchangeModel(nullptr)
    ,mImageProvider(nullptr)
    ,mAccountManager(new AccountManager())
    ,mCurrencyModel(nullptr)
    ,mAccountModel(nullptr)
    ,mClientSettings(nullptr)
    ,mIsBalanceUpdated(false)
    ,mBalanceTimer(-1)
{
    initSettings();
}

GraftBaseClient::~GraftBaseClient()
{
    delete mAccountManager;
}

void GraftBaseClient::setNetworkType(int networkType)
{
    if (mAccountManager)
    {
        mAccountManager->setNetworkType(networkType);
    }
    changeGraftHandler();
    emit networkTypeChanged();
}

int GraftBaseClient::networkType() const
{
    switch (mAccountManager->networkType())
    {
    case GraftClientTools::Mainnet:
        return GraftClientTools::Mainnet;
    case GraftClientTools::PublicTestnet:
        return GraftClientTools::PublicTestnet;
    case GraftClientTools::PublicExperimentalTestnet:
        return GraftClientTools::PublicExperimentalTestnet;
    default:
        return -1;
    }
}

bool GraftBaseClient::isAccountExists() const
{
    return !mAccountManager->account().isEmpty();
}

void GraftBaseClient::resetData()
{
    mAccountManager->clearData();
    graftHandler()->resetData();
    mBalances.clear();
    saveBalance();
    mIsBalanceUpdated = false;
    emit balanceUpdated();
}

void GraftBaseClient::createAccount(const QString &password)
{
    GraftBaseHandler *handler = graftHandler();
    if (handler)
    {
        if (mAccountManager->account().isEmpty())
        {
            connect(handler, &GraftBaseHandler::createAccountReceived,
                    this, &GraftBaseClient::receiveCreateAccount, Qt::UniqueConnection);
            mAccountManager->setPassword(password);
            handler->createAccount(password);
        }
        else
        {
            handler->setAccountData(mAccountManager->account(), mAccountManager->password());
        }
    }
}

void GraftBaseClient::restoreAccount(const QString &seed, const QString &password)
{
    GraftBaseHandler *handler = graftHandler();
    if (handler)
    {
        connect(handler, &GraftBaseHandler::restoreAccountReceived,
                this, &GraftBaseClient::receiveRestoreAccount, Qt::UniqueConnection);
        mAccountManager->setPassword(password);
        handler->restoreAccount(seed.toLower(), password);
    }
}

void GraftBaseClient::transfer(const QString &address, const QString &amount)
{
    GraftBaseHandler *handler = graftHandler();
    if (handler)
    {
        connect(handler, &GraftBaseHandler::transferReceived,
                this, &GraftBaseClient::receiveTransfer, Qt::UniqueConnection);
        QString customAmount = QString::number(GraftGenericAPIv1::toAtomic(amount.toDouble()),
                                               'f', 0);
        handler->transfer(address, customAmount);
    }
}

void GraftBaseClient::transferFee(const QString &address, const QString &amount)
{
    GraftBaseHandler *handler = graftHandler();
    if (handler)
    {
        connect(handler, &GraftBaseHandler::transferFeeReceived,
                this, &GraftBaseClient::receiveTransferFee, Qt::UniqueConnection);
        QString customAmount = QString::number(GraftGenericAPIv1::toAtomic(amount.toDouble()),
                                               'f', 0);
        handler->transferFee(address, customAmount);
    }
}

QString GraftBaseClient::getSeed() const
{
    return mAccountManager->seed();
}

QString GraftBaseClient::address() const
{
    return mAccountManager->address();
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
        mImageProvider->setBarcodeImage(scQRCodeImageID, image);
    }
}

void GraftBaseClient::registerTypes(QQmlEngine *engine)
{
    registerImageProvider(engine);
    initAccountModel(engine);
    initCurrencyModel(engine);
    initQuickExchangeModel(engine);
    qmlRegisterUncreatableType<GraftClientTools>("org.graft", 1, 0,
                                                 "GraftClientTools",
                                                 "You cannot create an instance of GraftClientTools type.");
}

QString GraftBaseClient::qrCodeImage() const
{
    return scProviderScheme.arg(scBarcodeImageProviderID).arg(scQRCodeImageID);
}

QString GraftBaseClient::addressQRCodeImage() const
{
    if (mImageProvider && mImageProvider->barcodeImage(scAddressQRCodeImageID).isNull())
    {
        updateAddressQRCode();
    }
    return scProviderScheme.arg(scBarcodeImageProviderID).arg(scAddressQRCodeImageID);
}

QString GraftBaseClient::coinAddressQRCodeImage(const QString &address) const
{
    mImageProvider->setBarcodeImage(scCoinAddressQRCodeImageID, QRCodeGenerator::encode(address));
    return scProviderScheme.arg(scBarcodeImageProviderID).arg(scCoinAddressQRCodeImageID);
}

void GraftBaseClient::saveAccounts() const
{
    saveModel(scAccountModelDataFile, AccountModelSerializator::serialize(mAccountModel));
}

void GraftBaseClient::updateBalance()
{
    if (graftHandler() && !mAccountManager->account().isEmpty())
    {
        graftHandler()->updateBalance();
    }
}

void GraftBaseClient::timerEvent(QTimerEvent *event)
{
    if (event->timerId() == mBalanceTimer)
    {
        updateBalance();
    }
}

void GraftBaseClient::initAccountSettings()
{
    if (graftHandler())
    {
        connect(graftHandler(), &GraftBaseHandler::balanceReceived, this,
                &GraftBaseClient::receiveBalance, Qt::UniqueConnection);
        if (isAccountExists())
        {
            graftHandler()->setAccountData(mAccountManager->account(), mAccountManager->password());
            updateBalance();
        }
    }
}

void GraftBaseClient::registerImageProvider(QQmlEngine *engine)
{
    if (!mImageProvider)
    {
        mImageProvider = new BarcodeImageProvider();
        engine->addImageProvider(scBarcodeImageProviderID, mImageProvider);
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

QStringList GraftBaseClient::getServiceAddresses(bool httpOnly) const
{
    QStringList addressList;
    QString type;
    bool isHttpsType = httpOnly ? false : httpsType();
    if (isHttpsType)
    {
        type = "s";
    }
    if (useOwnServiceAddress())
    {
        QString ip(settings(scIp).toString());
        QString port(settings(scPort).toString());
        addressList.append(QString("http%1://%2:%3").arg(type).arg(ip).arg(port));
    }
    else if (useOwnUrlAddress())
    {
        addressList.append(settings(scAddress).toString());
    }
    else
    {
        QStringList seeds = isHttpsType ? httpsSeedSupernodes() : httpSeedSupernodes();
        for (int i = 0; i < seeds.size(); ++i)
        {
            addressList << QString("http%1://%2").arg(type).arg(seeds.at(i));
        }
    }
    return addressList;
}

void GraftBaseClient::receiveCreateAccount(const QByteArray &accountData, const QString &password,
                                           const QString &address, const QString &viewKey,
                                           const QString &seed)
{
    bool isAccountCreated = false;
    if (mAccountManager->password() == password && !accountData.isEmpty() && !address.isEmpty())
    {
        mAccountManager->setAccount(accountData);
        mAccountManager->setAddress(address);
        mAccountManager->setViewKey(viewKey);
        mAccountManager->setSeed(seed);
        updateAddressQRCode();
        updateBalance();
        isAccountCreated = true;
    }
    emit createAccountReceived(isAccountCreated);
}

void GraftBaseClient::receiveRestoreAccount(const QByteArray &accountData, const QString &password,
                                            const QString &address, const QString &viewKey,
                                            const QString &seed)
{
    bool isAccountRestored = false;
    if (mAccountManager->password() == password && !accountData.isEmpty() &&!address.isEmpty())
    {
        mAccountManager->setAccount(accountData);
        mAccountManager->setAddress(address);
        mAccountManager->setViewKey(viewKey);
        mAccountManager->setSeed(seed);
        updateAddressQRCode();
        updateBalance();
        isAccountRestored = true;
    }
    emit restoreAccountReceived(isAccountRestored);
}

void GraftBaseClient::receiveBalance(double balance, double unlockedBalance)
{
    if (balance >= 0 && unlockedBalance >= 0)
    {
        mBalances.insert(GraftClientTools::LockedBalance, balance - unlockedBalance);
        mBalances.insert(GraftClientTools::UnlockedBalance, unlockedBalance);
        mBalances.insert(GraftClientTools::LocalBalance, unlockedBalance);
        saveBalance();
        mIsBalanceUpdated = true;
        emit balanceUpdated();
    }
}

void GraftBaseClient::receiveTransfer(int result)
{
    emit transferReceived(result == 0);
}

void GraftBaseClient::receiveTransferFee(int result, double fee)
{
    bool status = result == 0;
    double lFee = 0;
    if (status)
    {
        lFee = GraftGenericAPIv1::toCoins(fee);
    }
    emit transferFeeReceived(status, lFee);
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
        mCurrencyModel->add(QStringLiteral("BITCOIN"), QStringLiteral("BTC"));
        mCurrencyModel->add(QStringLiteral("BITCONNECT COIN"), QStringLiteral("BCC"));
        mCurrencyModel->add(QStringLiteral("DASH"), QStringLiteral("DASH"));
        mCurrencyModel->add(QStringLiteral("ETHER"), QStringLiteral("ETH"));
        mCurrencyModel->add(QStringLiteral("LITECOIN"), QStringLiteral("LTC"));
        mCurrencyModel->add(QStringLiteral("NEW ECONOMY MOVEMENT"), QStringLiteral("NEM"));
        mCurrencyModel->add(QStringLiteral("NEO"), QStringLiteral("NEO"));
        mCurrencyModel->add(QStringLiteral("RIPPLE"), QStringLiteral("XRP"));
        mCurrencyModel->add(QStringLiteral("MONERO"), QStringLiteral("XMR"));
        engine->rootContext()->setContextProperty(QStringLiteral("CoinModel"), mCurrencyModel);
    }
}

void GraftBaseClient::initQuickExchangeModel(QQmlEngine *engine)
{
    if(!mQuickExchangeModel)
    {
        mQuickExchangeModel = new QuickExchangeModel(this);
        mQuickExchangeModel->add(QStringLiteral("GRAFT"), QStringLiteral("grft"),
                                 QString(), true);
        engine->rootContext()->setContextProperty(QStringLiteral("QuickExchangeModel"),
                                                  mQuickExchangeModel);
    }
}

void GraftBaseClient::updateAddressQRCode() const
{
    if (mImageProvider)
    {
        mImageProvider->setBarcodeImage(scAddressQRCodeImageID, QRCodeGenerator::encode(address()));
    }
}

QString GraftBaseClient::versionNumber() const
{
    return scVersionNumber.toString();
}

bool GraftBaseClient::isDevMode() const
{
#ifdef DEV_MODE
    return true;
#endif
    return false;
}

QVariant GraftBaseClient::settings(const QString &key) const
{
    if (mClientSettings)
    {
        return mClientSettings->value(key);
    }
    return QVariant();
}

void GraftBaseClient::setSettings(const QString &key, const QVariant &value) const
{
    if (mClientSettings)
    {
        mClientSettings->setValue(key, value);
    }
}

void GraftBaseClient::updateSettings() const
{
    graftHandler()->changeAddresses(getServiceAddresses(), getServiceAddresses(true));
}

bool GraftBaseClient::httpsType() const
{
    if (mClientSettings)
    {
        return mClientSettings->value(scNetworkType, true).toBool();
    }
    return false;
}

bool GraftBaseClient::useOwnServiceAddress() const
{
    if (mClientSettings)
    {
        return mClientSettings->value(scUseOwnServiceAddress, false).toBool();
    }
    return false;
}

bool GraftBaseClient::useOwnUrlAddress() const
{
    if (mClientSettings)
    {
        return mClientSettings->value(scUseOwnUrlAddress, false).toBool();
    }
    return false;
}

bool GraftBaseClient::isValidIp(const QString &ip) const
{
    QHostAddress validateIp;
    return validateIp.setAddress(ip);
}

bool GraftBaseClient::isValidUrl(const QString &urlAddress) const
{
    return QUrl(urlAddress, QUrl::StrictMode).isValid();
}

double GraftBaseClient::balance(int type) const
{
    QString rValue = QString::number(mBalances.value(type, 0), 'f', 4);
    return rValue.toDouble();
}

void GraftBaseClient::saveBalance() const
{
    setSettings(scLockedBalance, mBalances.value(GraftClientTools::LockedBalance));
    setSettings(scUnlockedBalancee, mBalances.value(GraftClientTools::UnlockedBalance));
    setSettings(scLocalBalance, mBalances.value(GraftClientTools::LocalBalance));
    mClientSettings->sync();
}

void GraftBaseClient::updateQuickExchange(double cost)
{
    QStringList codes = mQuickExchangeModel->codeList();
    if (mQuickExchangeModel)
    {
        for (int i = 0; i < codes.count(); ++i)
        {
            mQuickExchangeModel->updatePrice(codes.value(i), QString::number(cost));
        }
    }
}

bool GraftBaseClient::checkPassword(const QString &password) const
{
    if (mAccountManager)
    {
        return mAccountManager->password() == password;
    }
    return false;
}

void GraftBaseClient::copyToClipboard(const QString &data) const
{
    QClipboard *clipboard = QGuiApplication::clipboard();
    clipboard->setText(data);
}

QString GraftBaseClient::networkName() const
{
    switch (mAccountManager->networkType())
    {
    case GraftClientTools::Mainnet:
        return MainnetConfiguration::scConfigTitle;
    case GraftClientTools::PublicTestnet:
        return TestnetConfiguration::scConfigTitle;
    case GraftClientTools::PublicExperimentalTestnet:
        return ExperimentalTestnetConfiguration::scConfigTitle;
    default:
        return QString();
    }
}

QString GraftBaseClient::dapiVersion() const
{
    switch (mAccountManager->networkType())
    {
    case GraftClientTools::Mainnet:
        return MainnetConfiguration::scDAPIVersion;
    case GraftClientTools::PublicTestnet:
        return TestnetConfiguration::scDAPIVersion;
    case GraftClientTools::PublicExperimentalTestnet:
        return ExperimentalTestnetConfiguration::scDAPIVersion;
    default:
        return QString();
    }
}

QStringList GraftBaseClient::httpSeedSupernodes() const
{
    switch (mAccountManager->networkType())
    {
    case GraftClientTools::Mainnet:
        return MainnetConfiguration::scHttpSeedSupernodes;
    case GraftClientTools::PublicTestnet:
        return TestnetConfiguration::scHttpSeedSupernodes;
    case GraftClientTools::PublicExperimentalTestnet:
        return ExperimentalTestnetConfiguration::scHttpSeedSupernodes;
    default:
        return QStringList();
    }
}

QStringList GraftBaseClient::httpsSeedSupernodes() const
{
    switch (mAccountManager->networkType())
    {
    case GraftClientTools::Mainnet:
        return MainnetConfiguration::scHttpsSeedSupernodes;
    case GraftClientTools::PublicTestnet:
        return TestnetConfiguration::scHttpsSeedSupernodes;
    case GraftClientTools::PublicExperimentalTestnet:
        return ExperimentalTestnetConfiguration::scHttpsSeedSupernodes;
    default:
        return QStringList();
    }
}

QString GraftBaseClient::wideSpacingSimplify(const QString &seed) const
{
    return seed.simplified();
}

bool GraftBaseClient::isBalanceUpdated() const
{
    return mIsBalanceUpdated;
}

void GraftBaseClient::saveSettings()
{
    if (mClientSettings)
    {
        mClientSettings->sync();
        updateSettings();
        emit settingsChanged();
    }
}

void GraftBaseClient::removeSettings() const
{
    if (mClientSettings)
    {
        QVariant licenseValue = mClientSettings->value(scLicense);
        mClientSettings->clear();
        mClientSettings->setValue(scLicense, licenseValue);
        mClientSettings->sync();
    }
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
    mBalances.insert(GraftClientTools::LockedBalance, settings(scLockedBalance).toDouble());
    mBalances.insert(GraftClientTools::UnlockedBalance, settings(scUnlockedBalancee).toDouble());
    mBalances.insert(GraftClientTools::LocalBalance, settings(scLocalBalance).toDouble());
    emit balanceUpdated();
}
