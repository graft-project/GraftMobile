#ifndef GRAFTPOSCLIENT_H
#define GRAFTPOSCLIENT_H

#include "graftbaseclient.h"

class SelectedProductProxyModel;
class ProductModel;
class GraftPOSAPI;

class GraftPOSClient : public GraftBaseClient
{
    Q_OBJECT
public:
    explicit GraftPOSClient(QObject *parent = nullptr);
    ~GraftPOSClient();

    ProductModel *productModel() const;
    SelectedProductProxyModel *selectedProductModel() const;

    void registerTypes(QQmlEngine *engine) override;

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
    GraftGenericAPI *graftAPI() const override;

    GraftPOSAPI *mApi;
    QString mPID;
    ProductModel *mProductModel;
    SelectedProductProxyModel *mSelectedProductModel;
};

#endif // GRAFTPOSCLIENT_H
