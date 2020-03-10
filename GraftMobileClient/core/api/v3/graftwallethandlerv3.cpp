#include "graftwallethandlerv3.h"
#include "graftwalletapiv3.h"

#include "core/txhistory/TransactionInfo.h"

#include <QTimer>
#include <QJsonArray>

#include <algorithm>




GraftWalletHandlerv3::GraftWalletHandlerv3(const QString &dapiVersion, const QStringList addresses,
                                           QObject *parent)
    : GraftWalletHandler(parent)
    ,mBlockNumber(0)
{
    mApi = new GraftWalletAPIv3(addresses, dapiVersion, this);
    connect(mApi, &GraftWalletAPIv3::createAccountReceived,
            this, &GraftWalletHandlerv3::createAccountReceived);
    connect(mApi, &GraftWalletAPIv3::restoreAccountReceived,
            this, &GraftWalletHandlerv3::restoreAccountReceived);
    connect(mApi, &GraftWalletAPIv3::transferFeeReceived,
            this, &GraftWalletHandlerv3::receiveTransferFee);
    connect(mApi, &GraftWalletAPIv3::transferReceived,
            this, &GraftWalletHandlerv3::receiveTransfer);
    connect(mApi, &GraftWalletAPIv3::balanceReceived, this, &GraftWalletHandlerv3::receiveBalance);

    connect(mApi, &GraftWalletAPIv3::getPOSDataReceived,
            this, &GraftWalletHandlerv3::saleDetailsReceived);
    connect(mApi, &GraftWalletAPIv3::rejectPayReceived,
            this, &GraftWalletHandlerv3::receiveRejectPay);
    connect(mApi, &GraftWalletAPIv3::payReceived, this, &GraftWalletHandlerv3::payReceived);
    connect(mApi, &GraftWalletAPIv3::getPayStatusReceived,
            this, &GraftWalletHandlerv3::receivePayStatus);
    connect(mApi, &GraftWalletAPIv3::error, this, &GraftWalletHandlerv3::errorReceived);
    connect(mApi, &GraftWalletAPIv3::transactionHistoryReceived, this, &GraftWalletHandlerv3::receiveTransactionHistory);
}

void GraftWalletHandlerv3::changeAddresses(const QStringList &addresses,
                                           const QStringList &internalAddresses)
{
    Q_UNUSED(internalAddresses);
    if (mApi)
    {
        mApi->changeAddresses(addresses);
    }
}

void GraftWalletHandlerv3::setAccountData(const QByteArray &accountData, const QString &password)
{
    if (mApi)
    {
        mApi->setAccountData(accountData, password);
    }
}

void GraftWalletHandlerv3::setNetworkManager(QNetworkAccessManager *networkManager)
{
    GraftWalletHandler::setNetworkManager(networkManager);
    if (mManager && mApi)
    {
        mApi->setNetworkManager(mManager);
    }
}

QByteArray GraftWalletHandlerv3::accountData() const
{
    if (mApi)
    {
        return mApi->accountData();
    }
    return QByteArray();
}

QString GraftWalletHandlerv3::password() const
{
    if (mApi)
    {
        return mApi->password();
    }
    return QString();
}

void GraftWalletHandlerv3::resetData()
{

}

void GraftWalletHandlerv3::createAccount(const QString &password)
{
    if (mApi)
    {
        mApi->createAccount(password);
    }
}

void GraftWalletHandlerv3::restoreAccount(const QString &seed, const QString &password)
{
    if (mApi)
    {
        mApi->restoreAccount(seed, password);
    }
}

void GraftWalletHandlerv3::updateBalance()
{
    if (mApi)
    {
        mApi->getBalance();
    }
}

void GraftWalletHandlerv3::updateTransactionHistory()
{
    if (mApi)
    {
        mApi->getTransactionHistory(m_lastTxHistoryBlock);
    }
}

void GraftWalletHandlerv3::transferFee(const QString &address, const QString &amount,
                                       const QString &paymentID)
{
    if (mApi)
    {
        mApi->transferFee(address, amount, paymentID);
    }
}

void GraftWalletHandlerv3::transfer(const QString &address, const QString &amount,
                                    const QString &paymentID)
{
    if (mApi)
    {
        mApi->transfer(address, amount, paymentID);
    }
}

void GraftWalletHandlerv3::saleDetails(const QString &pid, int blockNumber)
{
    if (mApi)
    {
        mApi->getPOSData(pid, blockNumber);
    }
}

void GraftWalletHandlerv3::rejectPay(const QString &pid, int blockNumber)
{
    if (mApi)
    {
        mApi->rejectPay(pid, blockNumber);
    }
}

void GraftWalletHandlerv3::pay(const QString &pid, const QString &address, double amount,
                               int blockNumber)
{
    if (mApi)
    {
        mLastPID = pid;
        mBlockNumber = blockNumber;
        mApi->pay(pid, address, amount, blockNumber);
    }
}

void GraftWalletHandlerv3::payStatus(const QString &pid, int blockNumber)
{
    Q_UNUSED(blockNumber);
    if (mApi)
    {
        mApi->getPayStatus(pid);
    }
}

void GraftWalletHandlerv3::receiveRejectPay(int result)
{
    emit rejectPayReceived(result == 0);
}

void GraftWalletHandlerv3::receivePayStatus(int result, int status)
{
    if (result == 0)
    {
        switch (status) {
        case GraftWalletAPIv3::StatusProcessing:
            payStatus(mLastPID, mBlockNumber);
            break;
        case GraftWalletAPIv3::StatusApproved:
            emit payStatusReceived(true);
            break;
        case GraftWalletAPIv3::StatusNone:
        case GraftWalletAPIv3::StatusFailed:
        case GraftWalletAPIv3::StatusPOSRejected:
        case GraftWalletAPIv3::StatusWalletRejected:
        default:
            emit payStatusReceived(false);
            break;
        }
    }
    else
    {
        emit payStatusReceived(false);
    }
}

void GraftWalletHandlerv3::receiveBalance(double balance, double unlockedBalance)
{
    QTimer::singleShot(20000, this, &GraftWalletHandlerv3::updateBalance);
    emit balanceReceived(balance, unlockedBalance);
}

void GraftWalletHandlerv3::receiveTransferFee(int result, double fee)
{
    bool status = result == 0;
    double lFee = 0;
    if (status)
    {
        lFee = GraftGenericAPIv3::toCoins(fee);
    }
    emit transferFeeReceived(status, lFee);
}

void GraftWalletHandlerv3::receiveTransfer(int result)
{
    emit transferReceived(result == 0);
}

void GraftWalletHandlerv3::receiveTransactionHistory(const QJsonArray &transfersOut, const QJsonArray &transfersIn, const QJsonArray &transfersPending, const QJsonArray &transfersFailed, const QJsonArray &transfersPool)
{
    QList<TransactionInfo*> tx_history;
    
    qDebug() << "received, outTxes: " << transfersOut.size()
             << " inTxes: " << transfersIn.size()
             << " pendingTxes: " << transfersPending.size()
             << " failedTxes: " << transfersFailed.size()
             << " poolTxes: " << transfersPool.size();
    
    auto process = [this](const QJsonArray & in, TransactionInfo::Direction direction, TransactionInfo::Status status, QList<TransactionInfo*> &out)
    {
        for (int i = 0; i < in.size(); ++i) {
            QJsonObject item = in.at(i).toObject();
            TransactionInfo * tx = nullptr;
            if (!item.isEmpty()) {
                if (status == TransactionInfo::Completed) {
                    tx  = TransactionInfo::createFromTransferEntry(item, direction, status);
                    out.push_back(tx);
                } else {
                    tx = TransactionInfo::createFromTransferEntry(item, item.value("type") == "out" ? TransactionInfo::Out : TransactionInfo::In,
                                                                             status);
                    out.push_front(tx);
                }
                if (tx->height() > m_lastTxHistoryBlock)
                    m_lastTxHistoryBlock = tx->height();    
                
                qDebug() << "added tx, status: " << tx->status() << ", direction: " << tx->direction();
            } else {
                qWarning() << "Empty tx";
            }
        }   
    };
    
    process(transfersOut, TransactionInfo::Out, TransactionInfo::Completed, tx_history);
    process(transfersIn, TransactionInfo::In, TransactionInfo::Completed, tx_history);
    
    // sort list by timestamp, descending order
    std::sort(tx_history.begin(), tx_history.end(), [](TransactionInfo *lhs, TransactionInfo *rhs)->bool {
       return  lhs->timestamp() > rhs->timestamp();
    });
    
    // direction not used for incomplete tx
    process(transfersPending, TransactionInfo::Out, TransactionInfo::Pending, tx_history);
    process(transfersPool, TransactionInfo::Out, TransactionInfo::Pending, tx_history);
    process(transfersFailed, TransactionInfo::Out, TransactionInfo::Pending, tx_history);

    qDebug() << "received tx count: " << tx_history.size();
    emit transactionHistoryReceived(tx_history);
}

