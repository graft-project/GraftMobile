#ifndef GRAFTWALLETCLIENT_H
#define GRAFTWALLETCLIENT_H

#include "graftbaseclient.h"

class GraftWalletAPI;
class ProductModel;

class GraftWalletClient : public GraftBaseClient
{
    Q_OBJECT
public:
    explicit GraftWalletClient(QObject *parent = nullptr);

    Q_INVOKABLE double totalCost() const;
    Q_INVOKABLE ProductModel *paymentProductModel() const;

signals:
    void readyToPayReceived(bool result);
    void rejectPayReceived(bool result);
    void payReceived(bool result);
    void payStatusReceived(bool result);

public slots:
    void readyToPay(const QString &data);
    void rejectPay();
    void pay();
    void getPayStatus();

private slots:
    void receiveReadyToPay(int result, const QString &transaction);
    void receiveRejectPay(int result);
    void receivePay(int result);
    void receivePayStatus(int result, int payStatus);

private:
    GraftWalletAPI *mApi;
    QString mPID;
    QString mPrivateKey;

    double mTotalCost;
    ProductModel *mPaymentProductModel;
};

#endif // GRAFTWALLETCLIENT_H
