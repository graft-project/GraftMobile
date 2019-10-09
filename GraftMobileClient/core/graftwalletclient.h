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

private slots:
    void receiveSaleDetails(int result, const QString &payDetails);
    void receivePay(int result);
    

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
