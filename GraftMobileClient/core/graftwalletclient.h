#ifndef GRAFTWALLETCLIENT_H
#define GRAFTWALLETCLIENT_H

#include "graftbaseclient.h"

class GraftWalletHandler;
class ProductModel;

class GraftWalletClient : public GraftBaseClient
{
    Q_OBJECT
public:
    explicit GraftWalletClient(QObject *parent = nullptr);

    Q_INVOKABLE double totalCost() const;
    Q_INVOKABLE ProductModel *paymentProductModel() const;

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

private slots:
    void receiveSaleDetails(int result, const QString &payDetails);
    void receiveRejectPay(int result);
    void receivePay(int result);
    void receivePayStatus(int result, int status);

private:
    void changeGraftHandler() override;
    GraftBaseHandler *graftHandler() const override;

    GraftWalletHandler *mClientHandler;
    QString mPID;
    QString mPrivateKey;
    int mBlockNumber;

    double mTotalCost;
    ProductModel *mPaymentProductModel;
};

#endif // GRAFTWALLETCLIENT_H
