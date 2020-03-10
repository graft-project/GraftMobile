#include "graftposhandlerv1.h"
#include "graftposapiv1.h"

#include <QTimer>

GraftPOSHandlerV1::GraftPOSHandlerV1(const QString &dapiVersion, const QStringList addresses,
                                     QObject *parent)
    : GraftPOSHandler(parent)
{
    mApi = new GraftPOSAPIv1(addresses, dapiVersion, this);
    connect(mApi, &GraftPOSAPIv1::createAccountReceived,
            this, &GraftPOSHandlerV1::createAccountReceived);
    connect(mApi, &GraftPOSAPIv1::restoreAccountReceived,
            this, &GraftPOSHandlerV1::restoreAccountReceived);
    connect(mApi, &GraftPOSAPIv1::transferFeeReceived,
            this, &GraftPOSHandlerV1::receiveTransferFee);
    connect(mApi, &GraftPOSAPIv1::transferReceived, this, &GraftPOSHandlerV1::receiveTransfer);
    connect(mApi, &GraftPOSAPIv1::balanceReceived, this, &GraftPOSHandlerV1::receiveBalance);

    connect(mApi, &GraftPOSAPIv1::saleResponseReceived, this, &GraftPOSHandlerV1::saleReceived);
    connect(mApi, &GraftPOSAPIv1::rejectSaleResponseReceived,
            this, &GraftPOSHandlerV1::receiveRejectSale);
    connect(mApi, &GraftPOSAPIv1::getSaleStatusResponseReceived,
            this, &GraftPOSHandlerV1::receiveSaleStatus);
    connect(mApi, &GraftPOSAPIv1::error, this, &GraftPOSHandlerV1::errorReceived);
}

void GraftPOSHandlerV1::changeAddresses(const QStringList &addresses, const QStringList &internalAddresses)
{
    Q_UNUSED(internalAddresses);
    if (mApi)
    {
        mApi->changeAddresses(addresses);
    }
}

void GraftPOSHandlerV1::setAccountData(const QByteArray &accountData, const QString &password)
{
    if (mApi)
    {
        mApi->setAccountData(accountData, password);
    }
}

void GraftPOSHandlerV1::setNetworkManager(QNetworkAccessManager *networkManager)
{
    GraftPOSHandler::setNetworkManager(networkManager);
    if (mManager && mApi)
    {
        mApi->setNetworkManager(mManager);
    }
}

QByteArray GraftPOSHandlerV1::accountData() const
{
    if (mApi)
    {
        return mApi->accountData();
    }
    return QByteArray();
}

QString GraftPOSHandlerV1::password() const
{
    if (mApi)
    {
        return mApi->password();
    }
    return QString();
}

void GraftPOSHandlerV1::resetData()
{

}

void GraftPOSHandlerV1::createAccount(const QString &password)
{
    if (mApi)
    {
        mApi->createAccount(password);
    }
}

void GraftPOSHandlerV1::restoreAccount(const QString &seed, const QString &password)
{
    if (mApi)
    {
        mApi->restoreAccount(seed, password);
    }
}

void GraftPOSHandlerV1::updateBalance()
{
    if (mApi)
    {
        mApi->getBalance();
    }
}

void GraftPOSHandlerV1::transferFee(const QString &address, const QString &amount,
                                    const QString &paymentID)
{
    if (mApi)
    {
        mApi->transferFee(address, amount, paymentID);
    }
}

void GraftPOSHandlerV1::transfer(const QString &address, const QString &amount,
                                 const QString &paymentID)
{
    if (mApi)
    {
        mApi->transfer(address, amount, paymentID);
    }
}

void GraftPOSHandlerV1::sale(const QString &address, const QString &viewKey,
                             double amount, const QString &saleDetails)
{
    if (mApi)
    {
        mApi->sale(address, viewKey, amount, saleDetails);
    }
}

void GraftPOSHandlerV1::rejectSale(const QString &pid)
{
    if (mApi)
    {
        mApi->rejectSale(pid);
    }
}

void GraftPOSHandlerV1::saleStatus(const QString &pid, int blockNumber)
{
    Q_UNUSED(blockNumber);
    if (mApi)
    {
        mLastPID = pid;
        mApi->getSaleStatus(pid);
    }
}

void GraftPOSHandlerV1::updateTransactionHistory()
{
  // dummy method
}

void GraftPOSHandlerV1::receiveRejectSale(int result)
{
    emit rejectSaleReceived(result == 0);
}

void GraftPOSHandlerV1::receiveSaleStatus(int result, int status)
{
    if (result == 0)
    {
        switch (status) {
        case GraftPOSAPIv1::StatusProcessing:
            saleStatus(mLastPID, 0);
            break;
        case GraftPOSAPIv1::StatusApproved:
            mLastPID.clear();
            emit saleStatusReceived(true);
            break;
        case GraftPOSAPIv1::StatusNone:
        case GraftPOSAPIv1::StatusFailed:
        case GraftPOSAPIv1::StatusPOSRejected:
        case GraftPOSAPIv1::StatusWalletRejected:
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

void GraftPOSHandlerV1::receiveBalance(double balance, double unlockedBalance)
{
    QTimer::singleShot(20000, this, &GraftPOSHandlerV1::updateBalance);
    emit balanceReceived(balance, unlockedBalance);
}

void GraftPOSHandlerV1::receiveTransferFee(int result, double fee)
{
    bool status = result == 0;
    double lFee = 0;
    if (status)
    {
        lFee = GraftGenericAPIv1::toCoins(fee);
    }
    emit transferFeeReceived(status, lFee);
}

void GraftPOSHandlerV1::receiveTransfer(int result)
{
    emit transferReceived(result == 0);
}
