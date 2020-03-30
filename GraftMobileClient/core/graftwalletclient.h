#ifndef GRAFTWALLETCLIENT_H
#define GRAFTWALLETCLIENT_H

#include "graftbaseclient.h"
#include "api/v3/graftgenericapiv3.h"

class GraftWalletHandler;
class ProductModel;


class GraftWalletClient : public GraftBaseClient
{
    Q_OBJECT
public:
    explicit GraftWalletClient(QObject *parent = nullptr);
    ~GraftWalletClient() override;

    Q_INVOKABLE double totalCost() const;
    Q_INVOKABLE ProductModel *paymentProductModel() const;
    Q_INVOKABLE bool isCorrectAddress(const QString &data) const;
    Q_INVOKABLE bool isSaleQrCodeValid(const QString &data) const;

signals:
    void saleDetailsReceived(bool result);
    void rejectPayReceived(bool result);
    void payReceived(bool result);
    void payStatusReceived(bool result);

public slots:
    void saleDetails(const QString &data);
    void rejectPay();
    void pay();
    void payStatus();
    void buildRtaTransaction();

private slots:
    void receiveSaleDetails(int result, const GraftGenericAPIv3::PaymentData &pd, const GraftGenericAPIv3::NodeAddress &addr);
    void receivePay(int result);
    void receiveBuildRtaTransaction(int result, const QString &errorMessage, const QStringList &ptxVector, double recepientAmount, 
                                    double feePerDestination);
    
    
    

private:
    void changeGraftHandler() override;
    GraftBaseHandler *graftHandler() const override;

    GraftWalletHandler *mClientHandler;
    QString mMerchantAddress;
    QString mMerchantKey;
    QStringList mKeys;    //  pos + pos proxy + wallet proxy + auth sample keys
    QStringList mWallets; //  pos proxy + wallet proxy + auth sample wallets
    QString mPID;
    QString mPrivateKey;
    int mBlockNumber;
    QString mBlockHash;
    double mTotalCost;
    ProductModel *mPaymentProductModel;
    QStringList mPtxList;
    
};

#endif // GRAFTWALLETCLIENT_H
