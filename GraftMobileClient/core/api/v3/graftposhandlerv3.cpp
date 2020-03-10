#include "graftposhandlerv3.h"
#include "graftposapiv3.h"

#include <QTimer>

GraftPOSHandlerV3::GraftPOSHandlerV3(const QString &dapiVersion, const QStringList addresses,
                                     QObject *parent)
    : GraftPOSHandler(parent)
{
    mApi = new GraftPOSAPIv3(addresses, dapiVersion, this);
    connect(mApi, &GraftPOSAPIv3::createAccountReceived,
            this, &GraftPOSHandlerV3::createAccountReceived);
    connect(mApi, &GraftPOSAPIv3::restoreAccountReceived,
            this, &GraftPOSHandlerV3::restoreAccountReceived);
    connect(mApi, &GraftPOSAPIv3::transferFeeReceived,
            this, &GraftPOSHandlerV3::receiveTransferFee);
    connect(mApi, &GraftPOSAPIv3::transferReceived, this, &GraftPOSHandlerV3::receiveTransfer);
    connect(mApi, &GraftPOSAPIv3::balanceReceived, this, &GraftPOSHandlerV3::receiveBalance);

    connect(mApi, &GraftPOSAPIv3::saleResponseReceived, this, &GraftPOSHandlerV3::saleReceived);
    connect(mApi, &GraftPOSAPIv3::rejectSaleResponseReceived,
            this, &GraftPOSHandlerV3::receiveRejectSale);
    connect(mApi, &GraftPOSAPIv3::getSaleStatusResponseReceived,
            this, &GraftPOSHandlerV3::receiveSaleStatus);
    connect(mApi, &GraftPOSAPIv3::error, this, &GraftPOSHandlerV3::errorReceived);
}

void GraftPOSHandlerV3::changeAddresses(const QStringList &addresses, const QStringList &internalAddresses)
{
    Q_UNUSED(internalAddresses);
    if (mApi)
    {
        mApi->changeAddresses(addresses);
    }
}

void GraftPOSHandlerV3::setAccountData(const QByteArray &accountData, const QString &password)
{
    if (mApi)
    {
        mApi->setAccountData(accountData, password);
    }
}

void GraftPOSHandlerV3::setNetworkManager(QNetworkAccessManager *networkManager)
{
    GraftPOSHandler::setNetworkManager(networkManager);
    if (mManager && mApi)
    {
        mApi->setNetworkManager(mManager);
    }
}

QByteArray GraftPOSHandlerV3::accountData() const
{
    if (mApi)
    {
        return mApi->accountData();
    }
    return QByteArray();
}

QString GraftPOSHandlerV3::password() const
{
    if (mApi)
    {
        return mApi->password();
    }
    return QString();
}

void GraftPOSHandlerV3::resetData()
{

}

void GraftPOSHandlerV3::createAccount(const QString &password)
{
    if (mApi)
    {
        mApi->createAccount(password);
    }
}

void GraftPOSHandlerV3::restoreAccount(const QString &seed, const QString &password)
{
    if (mApi)
    {
        mApi->restoreAccount(seed, password);
    }
}

void GraftPOSHandlerV3::updateBalance()
{
    if (mApi)
    {
        mApi->getBalance();
    }
}

void GraftPOSHandlerV3::transferFee(const QString &address, const QString &amount,
                                    const QString &paymentID)
{
    if (mApi)
    {
        mApi->transferFee(address, amount, paymentID);
    }
}

void GraftPOSHandlerV3::transfer(const QString &address, const QString &amount,
                                 const QString &paymentID)
{
    if (mApi)
    {
        mApi->transfer(address, amount, paymentID);
    }
}

void GraftPOSHandlerV3::sale(const QString &address, const QString &viewKey,
                             double amount, const QString &saleDetails)
{
    if (mApi)
    {
        mApi->sale(address, viewKey, amount, saleDetails);
    }
}

void GraftPOSHandlerV3::rejectSale(const QString &pid)
{
    if (mApi)
    {
        mApi->rejectSale(pid);
    }
}

void GraftPOSHandlerV3::saleStatus(const QString &pid, int blockNumber)
{
    Q_UNUSED(blockNumber);
    if (mApi)
    {
        mLastPID = pid;
        mApi->getSaleStatus(pid);
    }
}

void GraftPOSHandlerV3::updateTransactionHistory()
{
  // dummy method
}

void GraftPOSHandlerV3::receiveRejectSale(int result)
{
    emit rejectSaleReceived(result == 0);
}

void GraftPOSHandlerV3::receiveSaleStatus(int result, int status)
{
    if (result == 0)
    {
        switch (status) {
        case GraftPOSAPIv3::StatusProcessing:
            saleStatus(mLastPID, 0);
            break;
        case GraftPOSAPIv3::StatusApproved:
            mLastPID.clear();
            emit saleStatusReceived(true);
            break;
        case GraftPOSAPIv3::StatusNone:
        case GraftPOSAPIv3::StatusFailed:
        case GraftPOSAPIv3::StatusPOSRejected:
        case GraftPOSAPIv3::StatusWalletRejected:
        default:
            mLastPID.clear();
            emit saleStatusReceived(false);
            break;
        }
    }
    else
    {
        emit saleStatusReceived(false);
    }
}

void GraftPOSHandlerV3::receiveBalance(double balance, double unlockedBalance)
{
    QTimer::singleShot(20000, this, &GraftPOSHandlerV3::updateBalance);
    emit balanceReceived(balance, unlockedBalance);
}

void GraftPOSHandlerV3::receiveTransferFee(int result, double fee)
{
    bool status = result == 0;
    double lFee = 0;
    if (status)
    {
        lFee = GraftGenericAPIv3::toCoins(fee);
    }
    emit transferFeeReceived(status, lFee);
}

void GraftPOSHandlerV3::receiveTransfer(int result)
{
    emit transferReceived(result == 0);
}
