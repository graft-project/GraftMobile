#ifndef GRAFTWALLETHANDLER_H
#define GRAFTWALLETHANDLER_H

#include "graftbasehandler.h"
#include "v3/graftgenericapiv3.h"

class GraftWalletHandler : public GraftBaseHandler
{
    Q_OBJECT
public:
    explicit GraftWalletHandler(QObject *parent = nullptr) : GraftBaseHandler(parent) {}

public slots:
    virtual void saleDetails(const QString &pid, int blockNumber, const QString &blockHash) = 0;
    virtual void rejectPay(const QString &pid, int blockNumber) = 0;
    virtual void pay(const QString &pid, const QString &address,
                     double amount, int blockNumber) = 0;
    virtual void payStatus(const QString &pid, int blockNumber) = 0;
    virtual void buildRtaTransaction(const QString &pid, const QString &dstAddress, const QStringList &keys, const QStringList &wallets, 
                             double amount, double feeRatio, int blockNumber) = 0;
    virtual void getSupernodeInfo(const QStringList &keys) = 0;
    virtual void submitRtaTx(const QString &txHex, const QString &txKeyHex) = 0;
   

signals:
    void saleDetailsReceived(int result, const GraftGenericAPIv3::PaymentData &pd, const GraftGenericAPIv3::NodeAddress &walletProxy);
    void payReceived(int result);
    void rejectPayReceived(bool result);
    void payStatusReceived(bool result);
    void buildRtaTransactionReceived(int result, const QString &errorMessage, const QStringList &ptxVector, double recepientAmount, double feePerDestination);
    // TODO: name is too generic, right now we only need a wallet addresses;
    void getSupernodeInfoReceived(const QStringList &wallets);
};

#endif // GRAFTWALLETHANDLER_H


