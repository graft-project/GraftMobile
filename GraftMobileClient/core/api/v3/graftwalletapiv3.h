#ifndef GRAFTWALLETAPIV3_H
#define GRAFTWALLETAPIV3_H

#include "graftgenericapiv3.h"
#include "privatepaymentdetails.h"

class GraftWalletAPIv3 : public GraftGenericAPIv3
{
    Q_OBJECT
public:
    explicit GraftWalletAPIv3(const QStringList &addresses, const QString &dapiVersion,
                              QObject *parent = nullptr);

    void getPaymentData(const QString &pid, const QString &blockHash, quint64 blockHeight);
    void getSupernodeInfo(const QStringList &ids);
    void rejectPay(const QString &pid, int blockNum);
    void pay(const QString &pid, const QString &address, double amount, int blockNum);
    void buildRtaTransaction(const QString &pid, const QString &dstAddress, const QStringList &keys, const QStringList &wallets,
                             double amount, double feeRatio, int blockNumber);
    void submitRtaTx(const QString &encryptedTxBlob, const QString &encryptedTxKey);

signals:
    // void getPOSDataReceived(int result, const QString &payDetails);
    void paymentDataReceived(int status, const PaymentData &pd, const NodeAddress &walletProxy);
    void rejectPayReceived(int result);
    void payReceived(int result);
    void buildRtaTransactionReceived(int result, const QString &errorMessage, const QStringList &ptxBlobs, quint64 recepientAmount, quint64 feePerDestination);
    void supernodeInfoReceived(const QStringList &wallets);
private:
    void getPaymentData();
    
    
private slots:
    void receivePaymentDataResponse();
    void receiveRejectPayResponse();
    void receivePayResponse();
    void receiveBuildRtaTransactionResponse();
    void receiveGetSupernodeInfo();
    void receiveSubmitRtaTx();
    
    
private:
    QString mLastPID;
    QString mLastBlockHash;
    quint64 mLastBlockHeight  = 0;
};

#endif // GRAFTWALLETAPIv3_H
