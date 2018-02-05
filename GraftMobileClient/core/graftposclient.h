#ifndef GRAFTPOSCLIENT_H
#define GRAFTPOSCLIENT_H

#include "graftbaseclient.h"
#include <QVariant>

class SelectedProductProxyModel;
class ProductModel;
class GraftPOSAPI;

class GraftPOSClient : public GraftBaseClient
{
    Q_OBJECT
public:
    explicit GraftPOSClient(QObject *parent = nullptr);
    ~GraftPOSClient();

    Q_INVOKABLE void setNetworkType(int networkType) override;

    ProductModel *productModel() const;
    SelectedProductProxyModel *selectedProductModel() const;

    void registerTypes(QQmlEngine *engine) override;
    Q_INVOKABLE bool resetUrl(const QString &ip, const QString &port) override;

    Q_INVOKABLE void createAccount(const QString &password) override;
    Q_INVOKABLE void restoreAccount(const QString &seed, const QString &password) override;
    Q_INVOKABLE void transfer(const QString &address, const QString &amount) override;
    Q_INVOKABLE void transferFee(const QString &address, const QString &amount) override;

signals:
    void saleReceived(bool result);
    void rejectSaleReceived(bool result);
    void saleStatusReceived(bool result);

public slots:
    void saveProducts() const;
    void sale();
    void rejectSale();
    void getSaleStatus();

private slots:
    void receiveSale(int result, const QString &pid, int blockNum);
    void receiveRejectSale(int result);
    void receiveSaleStatus(int result, int saleStatus);

private:
    void initProductModels();
    void updateBalance() override;

    GraftPOSAPI *mApi;
    QString mPID;
    ProductModel *mProductModel;
    SelectedProductProxyModel *mSelectedProductModel;
};

#endif // GRAFTPOSCLIENT_H
