#ifndef GRAFTPOSCLIENT_H
#define GRAFTPOSCLIENT_H

#include "graftbaseclient.h"

class SelectedProductProxyModel;
class GraftPOSHandler;
class ProductModel;

class GraftPOSClient : public GraftBaseClient
{
    Q_OBJECT
public:
    explicit GraftPOSClient(QObject *parent = nullptr);
    ~GraftPOSClient() override;

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
    void saleStatus();

private slots:
    void receiveSale(int result, const QString &pid, int blockNumber);

private:
    void initProductModels();
    void changeGraftHandler() override;
    GraftBaseHandler *graftHandler() const override;

    GraftPOSHandler *mClientHandler;
    QString mPID;
    int mBlockNumber;
    ProductModel *mProductModel;
    SelectedProductProxyModel *mSelectedProductModel;
};

#endif // GRAFTPOSCLIENT_H
