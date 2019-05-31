#include "../../graftclienttools.h"
#include "graftposhandlerv2.h"
#include "graftposapiv2.h"
#include "graftwallet.h"

GraftPOSHandlerV2::GraftPOSHandlerV2(const QString &dapiVersion, const QStringList &addresses,
                                     const QStringList &internalAddresses, bool testnet,
                                     QObject *parent)
    : GraftPOSHandler(parent)
    ,mBlockNumber(0)
    ,tRetryStatus(false)
{
    mApi = new GraftPOSAPIv2(addresses, dapiVersion, this);
    connect(mApi, &GraftPOSAPIv2::saleResponseReceived, this, &GraftPOSHandlerV2::receiveSale);
    connect(mApi, &GraftPOSAPIv2::rejectSaleResponseReceived,
            this, &GraftPOSHandlerV2::receiveRejectSale);
    connect(mApi, &GraftPOSAPIv2::saleStatusResponseReceived,
            this, &GraftPOSHandlerV2::receiveSaleStatus);
    connect(mApi, &GraftPOSAPIv2::error, this, &GraftPOSHandlerV2::errorReceived);
    mWallet = new GraftWallet(this);
    mWallet->setTestnet(testnet);
    mWallet->changeAddresses(internalAddresses);
    connect(mWallet, &GraftWallet::refreshed, this, &GraftPOSHandlerV2::receiveBalance);
    connect(mWallet, &GraftWallet::transactionPrepared,
            this, &GraftPOSHandlerV2::receiveTransaction);
}

void GraftPOSHandlerV2::changeAddresses(const QStringList &addresses,
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

void GraftPOSHandlerV2::setAccountData(const QByteArray &accountData, const QString &password)
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

void GraftPOSHandlerV2::setNetworkManager(QNetworkAccessManager *networkManager)
{
    GraftPOSHandler::setNetworkManager(networkManager);
    if (mManager && mApi)
    {
        mApi->setNetworkManager(mManager);
    }
}

QByteArray GraftPOSHandlerV2::accountData() const
{
    if (mApi)
    {
        return mApi->accountData();
    }
    return QByteArray();
}

QString GraftPOSHandlerV2::password() const
{
    if (mApi)
    {
        return mApi->password();
    }
    return QString();
}

void GraftPOSHandlerV2::resetData()
{
    mWallet->closeWallet();
    mWallet->removeCache();
}

void GraftPOSHandlerV2::createAccount(const QString &password)
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

void GraftPOSHandlerV2::restoreAccount(const QString &seed, const QString &password)
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

void GraftPOSHandlerV2::updateBalance()
{
    if (mWallet)
    {
        mWallet->startRefresh();
    }
}

void GraftPOSHandlerV2::transferFee(const QString &address, const QString &amount,
                                    const QString &paymentID)
{
    if (mWallet)
    {
        mWallet->prepareTransactionAsync(address, amount.toULongLong(), paymentID);
    }
}

void GraftPOSHandlerV2::transfer(const QString &address, const QString &amount,
                                 const QString &paymentID)
{
    if (mWallet)
    {
        bool status = mWallet->sendCurrentTransaction();
        emit transferReceived(status);
    }
}

void GraftPOSHandlerV2::sale(const QString &address, const QString &viewKey, double amount,
                             const QString &saleDetails)
{
    if (mApi)
    {
        mApi->sale(address, amount, saleDetails);
    }
}

void GraftPOSHandlerV2::rejectSale(const QString &pid)
{
//    if (mApi)
//    {
//        mApi->rejectSale(pid);
//    }
    tRetryStatus = false;
}

void GraftPOSHandlerV2::saleStatus(const QString &pid, int blockNumber)
{
    if (mApi && tRetryStatus)
    {
        mLastPID = pid;
        mBlockNumber = blockNumber;
        mApi->saleStatus(pid, blockNumber);
    }
}

void GraftPOSHandlerV2::receiveBalance()
{
    if (mWallet)
    {
        double lockedBalance = GraftGenericAPIv2::toCoins(mWallet->lockedBalance());
        double unlockedBalance = GraftGenericAPIv2::toCoins(mWallet->unlockedBalance());
        emit balanceReceived(lockedBalance + unlockedBalance, unlockedBalance);
    }
}

void GraftPOSHandlerV2::receiveTransaction(bool result)
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

void GraftPOSHandlerV2::receiveSale(const QString &pid, int blockNumber)
{
    tRetryStatus = true;
    emit saleReceived(0, pid, blockNumber);
}

void GraftPOSHandlerV2::receiveRejectSale(int result)
{
    emit rejectSaleReceived(result == 0);
}

void GraftPOSHandlerV2::receiveSaleStatus(int status)
{
    switch (status) {
    case GraftPOSAPIv2::StatusWaiting:
    case GraftPOSAPIv2::StatusProcessing:
        saleStatus(mLastPID, mBlockNumber);
        break;
    case GraftPOSAPIv2::StatusSuccess:
        emit saleStatusReceived(true);
        break;
    case GraftPOSAPIv2::StatusNone:
    case GraftPOSAPIv2::StatusFailed:
    case GraftPOSAPIv2::StatusPOSRejected:
    case GraftPOSAPIv2::StatusWalletRejected:
    default:
        emit saleStatusReceived(false);
        break;
    }
}
