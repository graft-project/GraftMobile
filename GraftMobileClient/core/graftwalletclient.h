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
    Q_INVOKABLE bool resetUrl(const QString &ip, const QString &port) override;

signals:
    void getPOSDataReceived(bool result);
    void rejectPayReceived(bool result);
    void payReceived(bool result);
    void payStatusReceived(bool result);

public slots:
    void getPOSData(const QString &data);
    void rejectPay();
    void pay();
    void getPayStatus();

private slots:
    void receiveGetPOSData(int result, const QString &payDetails);
    void receiveRejectPay(int result);
    void receivePay(int result);
    void receivePayStatus(int result, int payStatus);

private:
    void updateBalance() override;

    GraftWalletAPI *mApi;
    QString mPID;
    QString mPrivateKey;
    int mBlockNum;

    double mTotalCost;
    ProductModel *mPaymentProductModel;
};

#endif // GRAFTWALLETCLIENT_H
