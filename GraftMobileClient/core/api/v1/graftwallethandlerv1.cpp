#include "graftwallethandlerv1.h"
#include "graftwalletapiv1.h"

#include "core/txhistory/TransactionInfo.h"

#include <QTimer>
#include <QJsonArray>

#include <algorithm>




GraftWalletHandlerV1::GraftWalletHandlerV1(const QString &dapiVersion, const QStringList addresses,
                                           QObject *parent)
    : GraftWalletHandler(parent)
    ,mBlockNumber(0)
{
    mApi = new GraftWalletAPIv1(addresses, dapiVersion, this);
    connect(mApi, &GraftWalletAPIv1::createAccountReceived,
            this, &GraftWalletHandlerV1::createAccountReceived);
    connect(mApi, &GraftWalletAPIv1::restoreAccountReceived,
            this, &GraftWalletHandlerV1::restoreAccountReceived);
    connect(mApi, &GraftWalletAPIv1::transferFeeReceived,
            this, &GraftWalletHandlerV1::receiveTransferFee);
    connect(mApi, &GraftWalletAPIv1::transferReceived,
            this, &GraftWalletHandlerV1::receiveTransfer);
    connect(mApi, &GraftWalletAPIv1::balanceReceived, this, &GraftWalletHandlerV1::receiveBalance);

    connect(mApi, &GraftWalletAPIv1::getPOSDataReceived,
            this, &GraftWalletHandlerV1::saleDetailsReceived);
    connect(mApi, &GraftWalletAPIv1::rejectPayReceived,
            this, &GraftWalletHandlerV1::receiveRejectPay);
    connect(mApi, &GraftWalletAPIv1::payReceived, this, &GraftWalletHandlerV1::payReceived);
    connect(mApi, &GraftWalletAPIv1::getPayStatusReceived,
            this, &GraftWalletHandlerV1::receivePayStatus);
    connect(mApi, &GraftWalletAPIv1::error, this, &GraftWalletHandlerV1::errorReceived);
    connect(mApi, &GraftWalletAPIv1::transactionHistoryReceived, this, &GraftWalletHandlerV1::receiveTransactionHistory);
}

void GraftWalletHandlerV1::changeAddresses(const QStringList &addresses,
                                           const QStringList &internalAddresses)
{
    Q_UNUSED(internalAddresses);
    if (mApi)
    {
        mApi->changeAddresses(addresses);
    }
}

void GraftWalletHandlerV1::setAccountData(const QByteArray &accountData, const QString &password)
{
    if (mApi)
    {
        mApi->setAccountData(accountData, password);
    }
}

void GraftWalletHandlerV1::setNetworkManager(QNetworkAccessManager *networkManager)
{
    GraftWalletHandler::setNetworkManager(networkManager);
    if (mManager && mApi)
    {
        mApi->setNetworkManager(mManager);
    }
}

QByteArray GraftWalletHandlerV1::accountData() const
{
    if (mApi)
    {
        return mApi->accountData();
    }
    return QByteArray();
}

QString GraftWalletHandlerV1::password() const
{
    if (mApi)
    {
        return mApi->password();
    }
    return QString();
}

void GraftWalletHandlerV1::resetData()
{

}

void GraftWalletHandlerV1::createAccount(const QString &password)
{
    if (mApi)
    {
        mApi->createAccount(password);
    }
}

void GraftWalletHandlerV1::restoreAccount(const QString &seed, const QString &password)
{
    if (mApi)
    {
        mApi->restoreAccount(seed, password);
    }
}

void GraftWalletHandlerV1::updateBalance()
{
    if (mApi)
    {
        mApi->getBalance();
    }
}

void GraftWalletHandlerV1::updateTransactionHistory()
{
    if (mApi)
    {
        mApi->getTransactionHistory(m_lastTxHistoryBlock);
    }
}

void GraftWalletHandlerV1::transferFee(const QString &address, const QString &amount,
                                       const QString &paymentID)
{
    if (mApi)
    {
        mApi->transferFee(address, amount, paymentID);
    }
}

void GraftWalletHandlerV1::transfer(const QString &address, const QString &amount,
                                    const QString &paymentID)
{
    if (mApi)
    {
        mApi->transfer(address, amount, paymentID);
    }
}

void GraftWalletHandlerV1::saleDetails(const QString &pid, int blockNumber)
{
    if (mApi)
    {
        mApi->getPOSData(pid, blockNumber);
    }
}

void GraftWalletHandlerV1::rejectPay(const QString &pid, int blockNumber)
{
    if (mApi)
    {
        mApi->rejectPay(pid, blockNumber);
    }
}

void GraftWalletHandlerV1::pay(const QString &pid, const QString &address, double amount,
                               int blockNumber)
{
    if (mApi)
    {
        mLastPID = pid;
        mBlockNumber = blockNumber;
        mApi->pay(pid, address, amount, blockNumber);
    }
}

void GraftWalletHandlerV1::payStatus(const QString &pid, int blockNumber)
{
    Q_UNUSED(blockNumber);
    if (mApi)
    {
        mApi->getPayStatus(pid);
    }
}

void GraftWalletHandlerV1::receiveRejectPay(int result)
{
    emit rejectPayReceived(result == 0);
}

void GraftWalletHandlerV1::receivePayStatus(int result, int status)
{
    if (result == 0)
    {
        switch (status) {
        case GraftWalletAPIv1::StatusProcessing:
            payStatus(mLastPID, mBlockNumber);
            break;
        case GraftWalletAPIv1::StatusApproved:
            emit payStatusReceived(true);
            break;
        case GraftWalletAPIv1::StatusNone:
        case GraftWalletAPIv1::StatusFailed:
        case GraftWalletAPIv1::StatusPOSRejected:
        case GraftWalletAPIv1::StatusWalletRejected:
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

void GraftWalletHandlerV1::receiveBalance(double balance, double unlockedBalance)
{
    QTimer::singleShot(20000, this, &GraftWalletHandlerV1::updateBalance);
    emit balanceReceived(balance, unlockedBalance);
}

void GraftWalletHandlerV1::receiveTransferFee(int result, double fee)
{
    bool status = result == 0;
    double lFee = 0;
    if (status)
    {
        lFee = GraftGenericAPIv1::toCoins(fee);
    }
    emit transferFeeReceived(status, lFee);
}

void GraftWalletHandlerV1::receiveTransfer(int result)
{
    emit transferReceived(result == 0);
}

void GraftWalletHandlerV1::receiveTransactionHistory(const QJsonArray &transfersOut, const QJsonArray &transfersIn, const QJsonArray &transfersPending, const QJsonArray &transfersFailed, const QJsonArray &transfersPool)
{
    QList<TransactionInfo*> tx_history;
    
    qDebug() << "received, outTxes: " << transfersOut.size()
             << " inTxes: " << transfersIn.size()
             << " pendingTxes: " << transfersPending.size()
             << " failedTxes: " << transfersFailed.size()
             << " poolTxes: " << transfersPool.size();
    
    for (int i = 0; i < transfersOut.size(); ++i) {
        QJsonObject item = transfersOut.at(i).toObject();
        if (!item.isEmpty()) {
            tx_history.push_back(TransactionInfo::createFromTransferEntry(item, TransactionInfo::Out, TransactionInfo::Completed));
            if (tx_history.back()->height() > m_lastTxHistoryBlock)
                m_lastTxHistoryBlock = tx_history.back()->height();
        } else {
            qWarning() << "Empty tx";
        }
    }
    
    for (int i = 0; i < transfersIn.size(); ++i) {
        QJsonObject item = transfersIn.at(i).toObject();
        if (!item.isEmpty()) {
            tx_history.push_back(TransactionInfo::createFromTransferEntry(item, TransactionInfo::In, TransactionInfo::Completed));
            if (tx_history.back()->height() > m_lastTxHistoryBlock)
                m_lastTxHistoryBlock = tx_history.back()->height();
        } else {
            qWarning() << "Empty tx";
        }
    }
    
    // sort list by timestamp, descending order
    std::sort(tx_history.begin(), tx_history.end(), [](TransactionInfo *lhs, TransactionInfo *rhs)->bool {
       return  lhs->timestamp() > rhs->timestamp();
    });
    
    for (int i = 0; i < transfersPending.size(); ++i) {
        QJsonObject item = transfersPending.at(i).toObject();
        if (!item.isEmpty()) {
            tx_history.push_front(TransactionInfo::createFromTransferEntry(item, item.value("type") == "out" ? TransactionInfo::Out : TransactionInfo::In,
                                                         TransactionInfo::Pending));
        } else {
            qWarning() << "Empty tx";
        }
    }
    for (int i = 0; i < transfersPool.size(); ++i) {
        QJsonObject item = transfersPool.at(i).toObject();
        if (!item.isEmpty()) {
            tx_history.push_front(TransactionInfo::createFromTransferEntry(item, item.value("type") == "out" ? TransactionInfo::Out : TransactionInfo::In,
                                                         TransactionInfo::Pending));
        } else {
            qWarning() << "Empty tx";
        }
    }
    
    for (int i = 0; i < transfersFailed.size(); ++i) {
        QJsonObject item = transfersFailed.at(i).toObject();
        if (!item.isEmpty()) {
            tx_history.push_front(TransactionInfo::createFromTransferEntry(item, item.value("type") == "out" ? TransactionInfo::Out : TransactionInfo::In,
                                                         TransactionInfo::Failed));
        } else {
            qWarning() << "Empty tx";
        }
    }
    qDebug() << "received tx count: " << tx_history.size();
    emit transactionHistoryReceived(tx_history);
}

