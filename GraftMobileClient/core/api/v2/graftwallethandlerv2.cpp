#include "graftwallethandlerv2.h"
#include "graftwalletapiv2.h"
#include "graftwallet.h"

GraftWalletHandlerV2::GraftWalletHandlerV2(const QString &dapiVersion, const QStringList &addresses,
                                           const QStringList &internalAddresses, bool testnet,
                                           QObject *parent)
    : GraftWalletHandler(parent)
{
    mApi = new GraftWalletAPIv2(addresses, dapiVersion, this);
    mApi->setNetworkManager(mManager);
    connect(mApi, &GraftWalletAPIv2::saleDetailsReceived,
            this, &GraftWalletHandlerV2::receiveSaleDetails);
    connect(mApi, &GraftWalletAPIv2::rejectPayReceived,
            this, &GraftWalletHandlerV2::receiveRejectPay);
    connect(mApi, &GraftWalletAPIv2::payReceived, this, &GraftWalletHandlerV2::payReceived);
    connect(mApi, &GraftWalletAPIv2::payStatusReceived,
            this, &GraftWalletHandlerV2::receivePayStatus);
    connect(mApi, &GraftWalletAPIv2::error, this, &GraftWalletHandlerV2::errorReceived);
    mWallet = new GraftWallet(this);
    mWallet->setTestnet(testnet);
    mWallet->changeAddresses(internalAddresses);
    connect(mWallet, &GraftWallet::refreshed, this, &GraftWalletHandlerV2::receiveBalance);
    connect(mWallet, &GraftWallet::transactionPrepared,
            this, &GraftWalletHandlerV2::receiveTransaction);
    connect(mWallet, &GraftWallet::rtaTransactionPrepared, this, &GraftWalletHandlerV2::sendPay);
}

void GraftWalletHandlerV2::changeAddresses(const QStringList &addresses,
                                           const QStringList &internalAddresses)
{
    if (mApi)
    {
        mApi->changeAddresses(addresses);
    }
    if (mWallet)
    {
        mWallet->changeAddresses(internalAddresses);
    }
}

void GraftWalletHandlerV2::setAccountData(const QByteArray &accountData, const QString &password)
{
    if (mApi)
    {
        mApi->setAccountData(accountData, password);
    }
    if (mWallet)
    {
        mWallet->restoreWallet(accountData, password);
    }
}

void GraftWalletHandlerV2::setNetworkManager(QNetworkAccessManager *networkManager)
{
    GraftBaseHandler::setNetworkManager(networkManager);
    if (mManager && mApi)
    {
        mApi->setNetworkManager(mManager);
    }
}

QByteArray GraftWalletHandlerV2::accountData() const
{
    if (mApi)
    {
        return mApi->accountData();
    }
    return QByteArray();
}

QString GraftWalletHandlerV2::password() const
{
    if (mApi)
    {
        return mApi->password();
    }
    return QString();
}

void GraftWalletHandlerV2::resetData()
{
    mWallet->closeWallet();
    mWallet->removeCache();
}

void GraftWalletHandlerV2::createAccount(const QString &password)
{
    if (mWallet)
    {
        bool isAccountCreated = mWallet->createWallet(password);
        if (isAccountCreated)
        {
            updateBalance();
        }
        emit createAccountReceived(mWallet->accountData(), password, mWallet->publicAddress(),
                                   mWallet->privateViewKey(), mWallet->seed());
    }
}

void GraftWalletHandlerV2::restoreAccount(const QString &seed, const QString &password)
{
    if (mWallet)
    {
        bool isAccountRestored = mWallet->restoreWallet(seed.toLower(), password);
        if (isAccountRestored)
        {
            updateBalance();
        }
        emit restoreAccountReceived(mWallet->accountData(), password, mWallet->publicAddress(),
                                    mWallet->privateViewKey(), mWallet->seed());
    }
}

void GraftWalletHandlerV2::updateBalance()
{
    if (mWallet)
    {
        mWallet->startRefresh();
    }
}

void GraftWalletHandlerV2::transferFee(const QString &address, const QString &amount,
                                       const QString &paymentID)
{
    if (mWallet)
    {
        mWallet->prepareTransactionAsync(address, amount.toULongLong(), paymentID);
    }
}

void GraftWalletHandlerV2::transfer(const QString &address, const QString &amount,
                                    const QString &paymentID)
{
    if (mWallet)
    {
        bool status = mWallet->sendCurrentTransaction();
        emit transferReceived(status);
    }
}

void GraftWalletHandlerV2::saleDetails(const QString &pid, int blockNumber)
{
    if (mApi)
    {
        mLastPID = pid;
        mBlockNumber = blockNumber;
        mApi->saleDetails(pid, blockNumber);
    }
    else
    {
        emit saleDetailsReceived(false, QString());
    }
}

void GraftWalletHandlerV2::rejectPay(const QString &pid, int blockNumber)
{
    //TODO: Fix support of rejectPay, unsupported on supernode side
    //mApi->rejectPay(mPID, mBlockNumber);
}

void GraftWalletHandlerV2::pay(const QString &pid, const QString &address, double amount,
                               int blockNumber)
{
    if (mWallet)
    {
        mLastPID = pid;
        mBlockNumber = blockNumber;
        mPOSAddress = address;
        mTotalCost = amount;
        QVector<QPair<QString, uint64_t>> destinations;
        uint64_t totalFee = 0;
        for (QPair<QString, QString> authNode : mAuthSample)
        {
            uint64_t fee = authNode.second.toULongLong();
            totalFee += fee;
            destinations.append(qMakePair(authNode.first, fee));
        }
        destinations.prepend(qMakePair(address, mApi->toAtomic(amount) - totalFee));
        mWallet->prepareRTATransactionAsync(destinations);
    }
}

void GraftWalletHandlerV2::payStatus(const QString &pid, int blockNumber)
{
    if (mApi)
    {
        mApi->payStatus(pid, blockNumber);
    }
}

void GraftWalletHandlerV2::receiveBalance()
{
    if (mWallet)
    {
        double lockedBalance = GraftGenericAPIv2::toCoins(mWallet->lockedBalance());
        double unlockedBalance = GraftGenericAPIv2::toCoins(mWallet->unlockedBalance());
        emit balanceReceived(lockedBalance + unlockedBalance, unlockedBalance);
    }
}

void GraftWalletHandlerV2::receiveTransaction(bool result)
{
    if (mWallet)
    {
        double lFee = 0;
        if (result)
        {
            lFee = GraftGenericAPIv2::toCoins(mWallet->currentTransactionFee());
        }
        else
        {
            emit errorReceived(mWallet->lastError());
        }
        emit transferFeeReceived(result, lFee);
    }
}

void GraftWalletHandlerV2::receiveSaleDetails(const QVector<QPair<QString, QString> > &authSample,
                                              const QString &saleDetails)
{
    mAuthSample = authSample;
    emit saleDetailsReceived(0, saleDetails);
}

void GraftWalletHandlerV2::sendPay(bool result)
{
    if (mWallet)
    {
        if (result)
        {
            QByteArrayList transactions = mWallet->getRawCurrentTransaction();
            mApi->pay(mLastPID, mPOSAddress, mTotalCost, mBlockNumber, transactions);
        }
        else
        {
            emit errorReceived(mWallet->lastError());
        }
    }
    else
    {
        emit errorReceived(tr("Wallet isn't initialized!"));
    }
}

void GraftWalletHandlerV2::receiveRejectPay(int result)
{
    emit rejectPayReceived(result == 0);
}

void GraftWalletHandlerV2::receivePayStatus(int status)
{
    switch (status) {
    case GraftWalletAPIv2::StatusWaiting:
    case GraftWalletAPIv2::StatusProcessing:
        payStatus(mLastPID, mBlockNumber);
        break;
    case GraftWalletAPIv2::StatusSuccess:
        processPayResult(true);
        break;
    case GraftWalletAPIv2::StatusNone:
    case GraftWalletAPIv2::StatusFailed:
    case GraftWalletAPIv2::StatusPOSRejected:
    case GraftWalletAPIv2::StatusWalletRejected:
    default:
        processPayResult(false);
        break;
    }
}

void GraftWalletHandlerV2::processPayResult(bool result)
{
    if (mWallet)
    {
        if (result)
        {
            mWallet->cacheCurrentTransaction();
        }
        mWallet->closeCurrentTransaction();
        mAuthSample.clear();
        mLastPID.clear();
        mBlockNumber = 0;
    }
    emit payStatusReceived(result);
}
