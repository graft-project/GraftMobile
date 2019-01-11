#include "graftwalletlistener.h"
#include "graftwallet.h"
#include <QtConcurrent/QtConcurrent>
#include <QStandardPaths>
#include <QFileInfo>
#include <QDir>
#include <QUrl>
#include <QDebug>

static const QString scWalletCacheFile("accountCache.dat");
static const std::string scLanguage("English");
static const uint64_t scUpperTransLimit(0);

GraftWallet::GraftWallet(QObject *parent)
    : QObject(parent)
    ,mTestnet(true)
    ,mWallet(nullptr)
    ,mListener(new GraftWalletListener(this))
    ,mCurrentTransaction(nullptr)
    ,mCurrentAddress(-1)
{
    Monero::WalletManagerFactory::setLogLevel(Monero::WalletManagerFactory::LogLevel_Max);
    mManager = Monero::WalletManagerFactory::getWalletManager();
}

GraftWallet::~GraftWallet()
{
    closeWallet();
//    delete mManager;
    delete mListener;
}

void GraftWallet::setTestnet(bool t)
{
    mTestnet = t;
}

bool GraftWallet::isTestnet() const
{
    return mTestnet;
}

void GraftWallet::changeAddresses(const QStringList &addresses)
{
    mAddresses = addresses;
    mCurrentAddress = -1;
    if (mWallet)
    {
        mWallet->init(nextAddress().toStdString(), scUpperTransLimit);
    }
}

bool GraftWallet::createWallet(const QString &password)
{
    if (!mWallet)
    {
        mWallet = mManager->createNewWallet(password.toStdString(), scLanguage, mTestnet);
        if (mWallet)
        {
            mWallet->setListener(mListener);
            mWallet->init(nextAddress().toStdString(), scUpperTransLimit);
            saveCache();
            return true;
        }
    }
    return false;
}

bool GraftWallet::restoreWallet(const QString &seed, const QString &password)
{
    if (!mWallet)
    {
        mWallet = mManager->restoreWallet(seed.toStdString(), mTestnet);
        if (mWallet)
        {
            mWallet->setListener(mListener);
            mWallet->init(nextAddress().toStdString(), scUpperTransLimit);
            saveCache();
            return true;
        }
    }
    return false;
}

bool GraftWallet::restoreWallet(const QByteArray &data, const QString &password)
{
    if (!mWallet)
    {
        mWallet = mManager->createWalletFromData(data.toStdString(), password.toStdString(),
                                                 mTestnet, cacheFilePath().toStdString());
        if (mWallet)
        {
            mWallet->setListener(mListener);
            mWallet->setSeedLanguage(scLanguage);
            mWallet->init(nextAddress().toStdString(), scUpperTransLimit);
            saveCache();
            return true;
        }
    }
    return false;
}

QString GraftWallet::seed() const
{
    if (mWallet)
    {
        return QString::fromStdString(mWallet->seed());
    }
    return QString();
}

QString GraftWallet::publicAddress() const
{
    if (mWallet)
    {
        return QString::fromStdString(mWallet->address());
    }
    return QString();
}

QByteArray GraftWallet::accountData() const
{
    if (mWallet)
    {
        return QByteArray::fromStdString(mWallet->getWalletData(""));
    }
    return QByteArray();
}

QString GraftWallet::publicViewKey() const
{
    if (mWallet)
    {
        return QString::fromStdString(mWallet->publicViewKey());
    }
    return QString();
}

QString GraftWallet::privateViewKey() const
{
    if (mWallet)
    {
        return QString::fromStdString(mWallet->secretViewKey());
    }
    return QString();
}

QString GraftWallet::publicSpendKey() const
{
    if (mWallet)
    {
        return QString::fromStdString(mWallet->publicSpendKey());
    }
    return QString();
}

QString GraftWallet::privateSpendKey() const
{
    if (mWallet)
    {
        return QString::fromStdString(mWallet->secretSpendKey());
    }
    return QString();
}

uint64_t GraftWallet::balance() const
{
    if (mWallet)
    {
        return mWallet->balance();
    }
    return 0;
}

uint64_t GraftWallet::unlockedBalance() const
{
    if (mWallet)
    {
        return mWallet->unlockedBalance();
    }
    return 0;
}

uint64_t GraftWallet::lockedBalance() const
{
    if (mWallet)
    {
        return mWallet->balance() - mWallet->unlockedBalance();
    }
    return 0;
}

bool GraftWallet::prepareTransaction(const QString &address, uint64_t amount)
{
    if (mWallet)
    {
        closeCurrentTransaction();
        mCurrentTransaction = mWallet->createTransaction(address.toStdString(), std::string(),
                                                         amount, 0);
        mLastError = QString::fromStdString(mWallet->errorString());
        return mCurrentTransaction->status() == Monero::PendingTransaction::Status_Ok;
    }
    return false;
}

bool GraftWallet::prepareTransactionAsync(const QString &address, uint64_t amount)
{
    if (mWallet)
    {
        closeCurrentTransaction();
        QFuture<bool> future = QtConcurrent::run(this, &GraftWallet::prepareTransaction,
                                                 address, amount);
        QFutureWatcher<bool> *watcher = new QFutureWatcher<bool>();
        connect(watcher, &QFutureWatcher<bool>::finished, this, [this, watcher]() {
            QFuture<bool> future = watcher->future();
            watcher->deleteLater();
            emit transactionPrepared(future.result());
        });
        watcher->setFuture(future);
        return true;
    }
    return false;
}

bool GraftWallet::prepareRTATransaction(const QVector<QPair<QString, uint64_t> > &addresses)
{
    if (mWallet)
    {
        closeCurrentTransaction();
        std::vector<Monero::Wallet::TransactionDestination> dests;
        for (auto address : addresses)
        {
            Monero::Wallet::TransactionDestination dst;
            dst.address = address.first.toStdString();
            dst.amount = address.second;
            dests.push_back(dst);
        }
        mCurrentTransaction = mWallet->createTransaction(dests, 0, true);
        mLastError = QString::fromStdString(mWallet->errorString());
        return mCurrentTransaction->status() == Monero::PendingTransaction::Status_Ok;
    }
    return false;
}

bool GraftWallet::prepareRTATransactionAsync(const QVector<QPair<QString, uint64_t> > &addresses)
{
    if (mWallet)
    {
        closeCurrentTransaction();
        QFuture<bool> future = QtConcurrent::run(this, &GraftWallet::prepareRTATransaction,
                                                 addresses);
        QFutureWatcher<bool> *watcher = new QFutureWatcher<bool>();
        connect(watcher, &QFutureWatcher<bool>::finished, this, [this, watcher]() {
            QFuture<bool> future = watcher->future();
            watcher->deleteLater();
            emit rtaTransactionPrepared(future.result());
        });
        watcher->setFuture(future);
        return true;
    }
    return false;
}

uint64_t GraftWallet::currentTransactionFee() const
{
    if (mWallet && mCurrentTransaction)
    {
        return mCurrentTransaction->fee();
    }
    return 0;
}

bool GraftWallet::sendCurrentTransaction()
{
    if (mWallet && mCurrentTransaction)
    {
        bool status = mCurrentTransaction->commit();
        if (!status)
        {
            mLastError = QString::fromStdString(mCurrentTransaction->errorString());
        }
        closeCurrentTransaction();
        return status;
    }
    return false;
}

void GraftWallet::cacheCurrentTransaction()
{
    if (mWallet && mCurrentTransaction)
    {
        mCurrentTransaction->updateTransactionCache();
    }
}

void GraftWallet::closeCurrentTransaction()
{
    if (mWallet && mCurrentTransaction)
    {
        mWallet->disposeTransaction(mCurrentTransaction);
        mCurrentTransaction = nullptr;
    }
}

QByteArrayList GraftWallet::getRawCurrentTransaction() const
{
    QByteArrayList data;
    if (mWallet)
    {
        std::vector<std::string> tx_data = mCurrentTransaction->getRawTransaction();
        for (auto it = tx_data.cbegin(); it != tx_data.cend(); ++it)
        {
            data.append(QByteArray::fromStdString(*it));
        }
    }
    return data;
}

QByteArrayList GraftWallet::getRawTransaction(const QString &address, uint64_t amount)
{
    QByteArrayList data;
    if (mWallet)
    {
        Monero::PendingTransaction *tx = mWallet->createTransaction(address.toStdString(), std::string(),
                                                                    amount, 0);
        std::vector<std::string> tx_data = tx->getRawTransaction();
        for (auto it = tx_data.cbegin(); it != tx_data.cend(); ++it)
        {
            data.append(QByteArray::fromStdString(*it));
        }
        mWallet->disposeTransaction(tx);
    }
    return data;
}

QByteArrayList GraftWallet::getRawTransaction(const QVector<QPair<QString, uint64_t> > &addresses)
{
    QByteArrayList data;
    if (mWallet)
    {
        std::vector<Monero::Wallet::TransactionDestination> dests;
        for (auto address : addresses)
        {
            Monero::Wallet::TransactionDestination dst;
            dst.address = address.first.toStdString();
            dst.amount = address.second;
            dests.push_back(dst);
        }
        Monero::PendingTransaction *tx = mWallet->createTransaction(dests, 0);
        std::vector<std::string> tx_data = tx->getRawTransaction();
        for (auto it = tx_data.cbegin(); it != tx_data.cend(); ++it)
        {
            data.append(QByteArray::fromStdString(*it));
        }
        mWallet->disposeTransaction(tx);
    }
    return data;
}

void GraftWallet::startRefresh()
{
    if (mWallet)
    {
        mWallet->startRefresh();
    }
}

void GraftWallet::saveCache() const
{
    if (mWallet)
    {
        mWallet->saveCache(cacheFilePath().toStdString());
    }
}

bool GraftWallet::removeCache() const
{
    QFile lFile(cacheFilePath());
    return lFile.remove();
}

void GraftWallet::closeWallet()
{
    if (mWallet)
    {
        mWallet->pauseRefresh();
        mManager->closeWallet(mWallet);
        delete mWallet;
        mWallet = nullptr;
    }
}

void GraftWallet::updateWallet()
{
    saveCache();
    emit updated();
}

void GraftWallet::refreshWallet()
{
    if (mWallet)
    {
        saveCache();
        if (mWallet->blockChainHeight() == mWallet->daemonBlockChainHeight())
        {
            emit refreshed();
        }
    }
}

QString GraftWallet::lastError() const
{
    if (mLastError.isEmpty() && mWallet)
    {
        return QString::fromStdString(mWallet->errorString());
    }
    return mLastError;
}

QString GraftWallet::nextAddress()
{
    mCurrentAddress++;
    if (mCurrentAddress >= mAddresses.count())
    {
        mCurrentAddress = 0;
    }
    //TODO: Use standard addresses
    return QUrl(mAddresses.value(mCurrentAddress)).authority();
//    return QStringLiteral("91.237.240.44:28881");
//    return QStringLiteral("34.239.181.212:28681");
//    return QStringLiteral("54.145.210.249:28681");
//    return QStringLiteral("54.236.111.68:28681");
}

QString GraftWallet::cacheFilePath() const
{
    QString dataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    if (!QFileInfo(dataPath).exists())
    {
        QDir().mkpath(dataPath);
    }
    QDir lDir(dataPath);
    return lDir.filePath(scWalletCacheFile);
}
