#include "accountmodelserializator.h"
#include "barcodeimageprovider.h"
#include "api/graftgenericapi.h"
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
static const QString scBarcodeImageProviderID("barcodes");
static const QString scQRCodeImageID("qrcode");
static const QString scAddressQRCodeImageID("address_qrcode");
static const QString scCoinAddressQRCodeImageID("coin_address_qrcode");
static const QString scProviderScheme("image://%1/%2");
static const QString scAccountModelDataFile("accountList.dat");
static const QString scSettingsDataFile("Settings.ini");
static const QString scIp("ip");
static const QString scPort("port");
static const QString scLockedBalance("lockedBalance");
static const QString scUnlockedBalancee("unlockedBalance");
static const QString scLocalBalance("localBalance");
static const QString scUseOwnServiceAddress("useOwnServiceAddress");
static const QString scNetworkType("httpsType");
static const QString scURLAddress("urlAddress");
static const QString scAddress("address");

GraftBaseClient::GraftBaseClient(QObject *parent)
    : QObject(parent)
    ,mImageProvider(nullptr)
    ,mAccountModel(nullptr)
    ,mCurrencyModel(nullptr)
    ,mQuickExchangeModel(nullptr)
    ,mAccountManager(new AccountManager())
    ,mClientSettings(nullptr)
    ,mBalanceTimer(-1)
    ,mIsBalanceUpdated(false)
{
    initSettings();
}

GraftBaseClient::~GraftBaseClient()
{
    delete mAccountManager;
}

void GraftBaseClient::setNetworkType(int networkType)
{
    mAccountManager->setNetworkType(networkType);
    graftAPI()->setDAPIVersion(dapiVersion());
    graftAPI()->changeAddresses(getServiceAddresses());
    emit networkTypeChanged();
}

int GraftBaseClient::networkType() const
{
    switch (mAccountManager->networkType()) {
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
    mBalances.clear();
    saveBalance();
    mIsBalanceUpdated = false;
    emit balanceUpdated();
}

void GraftBaseClient::createAccount(const QString &password)
{
    GraftGenericAPI *api = graftAPI();
    if (api)
    {
        if (mAccountManager->account().isEmpty())
        {
            connect(api, &GraftGenericAPI::createAccountReceived,
                    this, &GraftBaseClient::receiveAccount, Qt::UniqueConnection);
            mAccountManager->setPassword(password);
            api->createAccount(password);
        }
        else
        {
            api->setAccountData(mAccountManager->account(), mAccountManager->password());
        }
    }
}

void GraftBaseClient::restoreAccount(const QString &seed, const QString &password)
{
    GraftGenericAPI *api = graftAPI();
    if (api)
    {
        connect(api, &GraftGenericAPI::restoreAccountReceived,
                this, &GraftBaseClient::receiveRestoreAccount, Qt::UniqueConnection);
        mAccountManager->setPassword(password);
        api->restoreAccount(seed, password);
    }
}

void GraftBaseClient::transfer(const QString &address, const QString &amount)
{
    GraftGenericAPI *api = graftAPI();
    if (api)
    {
        connect(api, &GraftGenericAPI::transferReceived,
                this, &GraftBaseClient::receiveTransfer, Qt::UniqueConnection);
        QString customAmount = QString::number(GraftGenericAPI::toAtomic(amount.toDouble()), 'f', 0);
        api->transfer(address, customAmount);
    }
}

void GraftBaseClient::transferFee(const QString &address, const QString &amount)
{
    GraftGenericAPI *api = graftAPI();
    if (api)
    {
        connect(api, &GraftGenericAPI::transferFeeReceived,
                this, &GraftBaseClient::receiveTransferFee, Qt::UniqueConnection);
        QString customAmount = QString::number(GraftGenericAPI::toAtomic(amount.toDouble()), 'f', 0);
        api->transferFee(address, customAmount);
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
    graftAPI()->getBalance();
}

void GraftBaseClient::timerEvent(QTimerEvent *event)
{
    if (event->timerId() == mBalanceTimer && !mAccountManager->account().isEmpty())
    {
        updateBalance();
    }
}

void GraftBaseClient::initAccountSettings()
{
    if (graftAPI())
    {
        connect(graftAPI(), &GraftGenericAPI::getBalanceReceived, this,
                &GraftBaseClient::receiveBalance, Qt::UniqueConnection);
        if (isAccountExists())
        {
            graftAPI()->setAccountData(mAccountManager->account(), mAccountManager->password());
            updateBalance();
        }
//        mBalanceTimer = startTimer(20000);
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

QStringList GraftBaseClient::getServiceAddresses() const
{
    QStringList addressList;
    QString type;
    if (httpsType())
    {
        type = "s";
    }
    if (useOwnServiceAddress())
    {
        QString ip(settings(scIp).toString());
        QString port(settings(scPort).toString());
        addressList.append(QString("http%1://%2:%3").arg(type).arg(ip).arg(port));
    }
    else if (urlAddress())
    {
        addressList.append(settings(scAddress).toString());
    }
    else
    {
        for (int i = 0; i < seedSupernodes().size(); ++i)
        {
            addressList << QString("http%1://%2").arg(type).arg(seedSupernodes().at(i));
        }
    }
    return addressList;
}

void GraftBaseClient::receiveAccount(const QByteArray &accountData, const QString &password,
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
        QTimer::singleShot(20000, this, &GraftBaseClient::updateBalance);
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
        lFee = GraftGenericAPI::toCoins(fee);
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
        mQuickExchangeModel->add(QStringLiteral("US Dollar"), QStringLiteral("USD"),
                                 QString(), true);
        engine->rootContext()->setContextProperty(QStringLiteral("QuickExchangeModel"),
                                                  mQuickExchangeModel);
    }
}

void GraftBaseClient::updateAddressQRCode() const
{
    mImageProvider->setBarcodeImage(scAddressQRCodeImageID, QRCodeGenerator::encode(address()));
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
    return mClientSettings->value(key);
}

void GraftBaseClient::setSettings(const QString &key, const QVariant &value) const
{
    mClientSettings->setValue(key, value);
}

bool GraftBaseClient::useOwnServiceAddress() const
{
    return mClientSettings->value(scUseOwnServiceAddress).toBool();
}

bool GraftBaseClient::resetUrl(const QString &ip, const QString &port)
{
    bool lIsResetUrl = (useOwnServiceAddress() && isValidIp(ip) && !port.isEmpty());
    if (lIsResetUrl)
    {
        setSettings(scIp, ip);
        setSettings(scPort, port);
        graftAPI()->changeAddresses(getServiceAddresses());
    }
    return lIsResetUrl;
}

bool GraftBaseClient::isValidIp(const QString &ip) const
{
    QHostAddress validateIp;
    return validateIp.setAddress(ip);
}

bool GraftBaseClient::urlAddress() const
{
    return mClientSettings->value(scURLAddress).toBool();
}

bool GraftBaseClient::httpsType() const
{
    return mClientSettings->value(scNetworkType, true).toBool();
}

void GraftBaseClient::resetType() const
{
    graftAPI()->changeAddresses(getServiceAddresses());
}

bool GraftBaseClient::resetUrlAddress(const QString &url)
{
    bool lIsResetUrl = (urlAddress() && isValidUrl(url));
    if (lIsResetUrl)
    {
        setSettings(scAddress, url);
        graftAPI()->changeAddresses(getServiceAddresses());
    }
    return lIsResetUrl;
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
    saveSettings();
}

void GraftBaseClient::updateQuickExchange(double cost)
{
    QStringList codes = mQuickExchangeModel->codeList();
    for (int i = 0; i < codes.count(); ++i)
    {
        mQuickExchangeModel->updatePrice(codes.value(i), QString::number(cost));
    }
}

bool GraftBaseClient::checkPassword(const QString &password) const
{
    return mAccountManager->password() == password;
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

QStringList GraftBaseClient::seedSupernodes() const
{
    switch (mAccountManager->networkType())
    {
    case GraftClientTools::Mainnet:
        return MainnetConfiguration::scSeedSupernodes;
    case GraftClientTools::PublicTestnet:
        return TestnetConfiguration::scSeedSupernodes;
    case GraftClientTools::PublicExperimentalTestnet:
        return ExperimentalTestnetConfiguration::scSeedSupernodes;
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

void GraftBaseClient::saveSettings() const
{
    mClientSettings->sync();
}

void GraftBaseClient::removeSettings() const
{
    mClientSettings->remove(QStringLiteral("companyName"));
    mClientSettings->remove(QStringLiteral("useOwnServiceAddress"));
    mClientSettings->remove(QStringLiteral("ip"));
    mClientSettings->remove(QStringLiteral("port"));
    mClientSettings->remove(QStringLiteral("localBalance"));
    mClientSettings->remove(QStringLiteral("unlockedBalance"));
    mClientSettings->remove(QStringLiteral("lockedBalance"));
    mClientSettings->remove(QStringLiteral("httpsType"));
    mClientSettings->remove(QStringLiteral("urlAddress"));
    mClientSettings->remove(QStringLiteral("address"));
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
    mBalances.insert(GraftClientTools::LockedBalance, settings(scLockedBalance).toDouble());
    mBalances.insert(GraftClientTools::UnlockedBalance, settings(scUnlockedBalancee).toDouble());
    mBalances.insert(GraftClientTools::LocalBalance, settings(scLocalBalance).toDouble());
    emit balanceUpdated();
}
