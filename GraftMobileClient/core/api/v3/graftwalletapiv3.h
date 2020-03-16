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
    void rejectPay(const QString &pid, int blockNum);
    void pay(const QString &pid, const QString &address, double amount, int blockNum);
    void getPayStatus(const QString &pid);

signals:
    // void getPOSDataReceived(int result, const QString &payDetails);
    void paymentDataReceived(int status, const PaymentData &pd, const NodeAddress &walletProxy);
    
    void rejectPayReceived(int result);
    void payReceived(int result);
    void getPayStatusReceived(int result, int status);

private:
    void getPaymentData();
    
private slots:
    void receivePaymentDataResponse();
    void receiveRejectPayResponse();
    void receivePayResponse();
    void receivePayStatusResponse();
    
    
private:
    QString mLastPID;
    QString mLastBlockHash;
    quint64 mLastBlockHeight  = 0;
    
};

#endif // GRAFTWALLETAPIv3_H
