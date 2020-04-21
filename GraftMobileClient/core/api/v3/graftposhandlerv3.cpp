#include "graftposhandlerv3.h"
#include "graftposapiv3.h"

#include <QTimer>
#include <QDebug>

GraftPOSHandlerV3::GraftPOSHandlerV3(const QString &dapiVersion, GraftGenericAPIv3::NetType nettype, const QStringList addresses,
                                     QObject *parent)
    : GraftPOSHandler(parent)
{
    mApi = new GraftPOSAPIv3(addresses, nettype, dapiVersion, this);
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
    connect(mApi, &GraftGenericAPIv3::saleStatusResponseReceived, this, &GraftPOSHandlerV3::receiveSaleStatus);
    connect(mApi, &GraftPOSAPIv3::rtaTxValidated, this, &GraftPOSHandlerV3::receiveRtaTxValidated);
    connect(mApi, &GraftPOSAPIv3::saleApproveProcessed, this, &GraftPOSHandlerV3::receiveSaleApproveProcessed);
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

PrivatePaymentDetails GraftPOSHandlerV3::paymentRequest() const
{
    PrivatePaymentDetails result;
    result.blockHash    = mApi->blockHash();
    result.blockHeight  = mApi->blockHeight();
    result.paymentId    = mApi->paymentId();
    result.posAddress.Id   = mApi->posPubkey();
    result.key = mApi->walletEncryptionKey();
    return result;   
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

void GraftPOSHandlerV3::sale(const QString &address, 
                             double amount, const QString &saleDetails)
{
    if (mApi)
    {
        mPaymentTimer.start();
        m_rtaTxProcessed = false;
        mApi->sale(address, amount, saleDetails);
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
    Q_UNUSED(blockNumber)
    if (mApi)
    {
        mLastPID = pid;
        mApi->saleStatus(pid, blockNumber);
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

void GraftPOSHandlerV3::receiveSaleStatus(int status)
{
    qDebug() << __FUNCTION__ << ": " << status;
    
    switch (status) {
    case GraftPOSAPIv3::None: // no rta tx published  yet, keep polling
        if (mPaymentTimer.hasExpired(PAYMENT_STARTED_MAX_WAIT_TIME_MS)) {
            qCritical() << "Payment wasn't processed in " << PAYMENT_STARTED_MAX_WAIT_TIME_MS/1000.0 << " seconds";
            emit saleStatusReceived(false);
            
        } else {
            if (!mLastPID.isEmpty()) {
                QTimer::singleShot(1000, [this]() {
                    saleStatus(mLastPID, 0);
                });
            }
        }
        break;
    case GraftPOSAPIv3::InProgress: // rta transaction published, quorum started to validate it
        if (m_saleStatus != GraftPOSAPIv3::InProgress)
            mPaymentTimer.start();
        
        if (mPaymentTimer.hasExpired(PAYMENT_COMPLETED_MAX_WAIT_TIME_MS)) {
            qCritical() << "Payment wasn't processed in " << PAYMENT_COMPLETED_MAX_WAIT_TIME_MS/1000.0 << " seconds";
            emit saleStatusReceived(false);
            return;
        }
        
        if (!m_rtaTxProcessed) {
            mApi->getRtaTx(mLastPID);
        } else {
            QTimer::singleShot(1000, [this]() {
                saleStatus(mLastPID, 0);
            }); 
        }
        break;
    case GraftPOSAPIv3::Success:
        mLastPID.clear();
        
        emit saleStatusReceived(true);
        break;
        // TODO: threat errors different way
    case GraftPOSAPIv3::FailRejectedByPOS:
    case GraftPOSAPIv3::FailZeroFee:
    case GraftPOSAPIv3::FailDoubleSpend:
    case GraftPOSAPIv3::FailTimedOut:
    case GraftPOSAPIv3::FailTxRejected:
    default:
        mLastPID.clear();
        emit saleStatusReceived(false);
        break;
    }
    if (m_saleStatus != status)
        m_saleStatus = status;
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

void GraftPOSHandlerV3::receiveRtaTxValidated(bool result)
{
    m_rtaTxProcessed = true;
    if (!result) {
        emit saleStatusReceived(result);
    } else {
        m_rtaTxProcessed = true;
        // call api->approveSale();
        mApi->approveSale(mLastPID);
    }
}

void GraftPOSHandlerV3::receiveSaleApproveProcessed(bool result)
{
    if (!result) {
        emit saleStatusReceived(false);
    } else {
        // keep polling for sale status
        mApi->saleStatus(mLastPID, 0);
    }
        
       
}

