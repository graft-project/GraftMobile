#include "graftwallethandlerv3.h"
#include "graftwalletapiv3.h"

#include "core/txhistory/TransactionInfo.h"

#include <QTimer>
#include <QJsonArray>

#include <algorithm>




GraftWalletHandlerV3::GraftWalletHandlerV3(const QString &dapiVersion, const QStringList addresses,
                                           QObject *parent)
    : GraftWalletHandler(parent)
    ,mBlockNumber(0)
{
    mApi = new GraftWalletAPIv3(addresses, dapiVersion, this);
    connect(mApi, &GraftWalletAPIv3::createAccountReceived,
            this, &GraftWalletHandlerV3::createAccountReceived);
    connect(mApi, &GraftWalletAPIv3::restoreAccountReceived,
            this, &GraftWalletHandlerV3::restoreAccountReceived);
    connect(mApi, &GraftWalletAPIv3::transferFeeReceived,
            this, &GraftWalletHandlerV3::receiveTransferFee);
    connect(mApi, &GraftWalletAPIv3::transferReceived,
            this, &GraftWalletHandlerV3::receiveTransfer);
    connect(mApi, &GraftWalletAPIv3::balanceReceived, this, &GraftWalletHandlerV3::receiveBalance);

    connect(mApi, &GraftWalletAPIv3::paymentDataReceived,
            this, &GraftWalletHandlerV3::saleDetailsReceived);
    connect(mApi, &GraftWalletAPIv3::rejectPayReceived,
            this, &GraftWalletHandlerV3::receiveRejectPay);
    connect(mApi, &GraftWalletAPIv3::payReceived, this, &GraftWalletHandlerV3::payReceived);
    connect(mApi, &GraftGenericAPIv3::saleStatusResponseReceived,
            this, &GraftWalletHandlerV3::receivePayStatus);
    connect(mApi, &GraftWalletAPIv3::error, this, &GraftWalletHandlerV3::errorReceived);
    connect(mApi, &GraftWalletAPIv3::transactionHistoryReceived, this, &GraftWalletHandlerV3::receiveTransactionHistory);
    connect(mApi, &GraftWalletAPIv3::supernodeInfoReceived, this, &GraftWalletHandlerV3::receiveSupernodeInfo);
    connect(mApi, &GraftWalletAPIv3::buildRtaTransactionReceived, this, &GraftWalletHandlerV3::receiveBuildRtaTransaction);
}

void GraftWalletHandlerV3::changeAddresses(const QStringList &addresses,
                                           const QStringList &internalAddresses)
{
    Q_UNUSED(internalAddresses);
    if (mApi)
    {
        mApi->changeAddresses(addresses);
    }
}

void GraftWalletHandlerV3::setAccountData(const QByteArray &accountData, const QString &password)
{
    if (mApi)
    {
        mApi->setAccountData(accountData, password);
    }
}

void GraftWalletHandlerV3::setNetworkManager(QNetworkAccessManager *networkManager)
{
    GraftWalletHandler::setNetworkManager(networkManager);
    if (mManager && mApi)
    {
        mApi->setNetworkManager(mManager);
    }
}

QByteArray GraftWalletHandlerV3::accountData() const
{
    if (mApi)
    {
        return mApi->accountData();
    }
    return QByteArray();
}

QString GraftWalletHandlerV3::password() const
{
    if (mApi)
    {
        return mApi->password();
    }
    return QString();
}

void GraftWalletHandlerV3::resetData()
{

}

void GraftWalletHandlerV3::createAccount(const QString &password)
{
    if (mApi)
    {
        mApi->createAccount(password);
    }
}

void GraftWalletHandlerV3::restoreAccount(const QString &seed, const QString &password)
{
    if (mApi)
    {
        mApi->restoreAccount(seed, password);
    }
}

void GraftWalletHandlerV3::updateBalance()
{
    if (mApi)
    {
        mApi->getBalance();
    }
}

void GraftWalletHandlerV3::updateTransactionHistory()
{
    if (mApi)
    {
        mApi->getTransactionHistory(m_lastTxHistoryBlock);
    }
}

void GraftWalletHandlerV3::transferFee(const QString &address, const QString &amount,
                                       const QString &paymentID)
{
    if (mApi)
    {
        mApi->transferFee(address, amount, paymentID);
    }
}

void GraftWalletHandlerV3::transfer(const QString &address, const QString &amount,
                                    const QString &paymentID)
{
    if (mApi)
    {
        mApi->transfer(address, amount, paymentID);
    }
}

void GraftWalletHandlerV3::saleDetails(const QString &pid, int blockNumber, const QString &blockHash)
{
    if (mApi)
    {
        mApi->getPaymentData(pid, blockHash, (quint64) blockNumber);
    }
}

void GraftWalletHandlerV3::rejectPay(const QString &pid, int blockNumber)
{
    if (mApi)
    {
        mApi->rejectPay(pid, blockNumber);
    }
}

void GraftWalletHandlerV3::pay(const QString &pid, const QString &address, double amount,
                               int blockNumber)
{
    if (mApi)
    {
        mLastPID = pid;
        mBlockNumber = blockNumber;
        mApi->pay(pid, address, amount, blockNumber);
    }
}

void GraftWalletHandlerV3::payStatus(const QString &pid, int blockNumber)
{
    if (mApi)
    {
        qDebug() << "Polling payment status: " << pid;
        mApi->saleStatus(pid, blockNumber);
    }
}

void GraftWalletHandlerV3::buildRtaTransaction(const QString &pid, const QString &dstAddress, const QStringList &keys, const QStringList &wallets,  double amount, double feeRatio, int blockNumber)
{
    if (mApi) {
        mLastPID = pid;
        mBlockNumber = blockNumber;
        mApi->buildRtaTransaction(pid, dstAddress, keys, wallets, amount, feeRatio, blockNumber);
    }
}

void GraftWalletHandlerV3::getSupernodeInfo(const QStringList &keys)
{
    if (mApi) {
        mApi->getSupernodeInfo(keys);
    }
}

void GraftWalletHandlerV3::submitRtaTx(const QString &txHex, const QString &txKeyHex)
{
    if (mApi) {
        mApi->submitRtaTx(txHex, txKeyHex);
    }
}


void GraftWalletHandlerV3::receiveRejectPay(int result)
{
    emit rejectPayReceived(result == 0);
}

void GraftWalletHandlerV3::receivePayStatus(int status)
{
    if ((true))
    {
        switch (status) {
        case GraftWalletAPIv3::None:
        case GraftWalletAPIv3::InProgress:
            QTimer::singleShot(1000, [this]() {
                payStatus(mLastPID, mBlockNumber);
            });
            break;
        case GraftWalletAPIv3::Success:
            emit payStatusReceived(true);
            break;
        
        case GraftWalletAPIv3::FailTxRejected:
        case GraftWalletAPIv3::FailTimedOut:
        case GraftWalletAPIv3::FailZeroFee:
        case GraftWalletAPIv3::FailRejectedByPOS:
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

void GraftWalletHandlerV3::receiveBalance(double balance, double unlockedBalance)
{
    QTimer::singleShot(20000, this, &GraftWalletHandlerV3::updateBalance);
    emit balanceReceived(balance, unlockedBalance);
}

void GraftWalletHandlerV3::receiveTransferFee(int result, double fee)
{
    bool status = result == 0;
    double lFee = 0;
    if (status)
    {
        lFee = GraftGenericAPIv3::toCoins(fee);
    }
    emit transferFeeReceived(status, lFee);
}

void GraftWalletHandlerV3::receiveTransfer(int result)
{
    emit transferReceived(result == 0);
}

void GraftWalletHandlerV3::receiveTransactionHistory(const QJsonArray &transfersOut, const QJsonArray &transfersIn, const QJsonArray &transfersPending, const QJsonArray &transfersFailed, const QJsonArray &transfersPool)
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

void GraftWalletHandlerV3::receiveBuildRtaTransaction(int result, const QString &errorMessage, const QStringList &ptxVector, double recipientAmount, double feePerDestination)
{
    emit buildRtaTransactionReceived(result, errorMessage, ptxVector, recipientAmount, feePerDestination);
}

void GraftWalletHandlerV3::receiveSupernodeInfo(const QStringList &wallets)
{
    // TODO: check if wallets match to keys
    emit getSupernodeInfoReceived(wallets);

}

