#ifndef GRAFTPOSCLIENT_H
#define GRAFTPOSCLIENT_H

#include "graftbaseclient.h"

class SelectedProductProxyModel;
class PatrickQRCodeEncoder;
class ProductModel;
class GraftPOSAPI;

class GraftPOSClient : public GraftBaseClient
{
    Q_OBJECT
public:
    explicit GraftPOSClient(QObject *parent = nullptr);
    ~GraftPOSClient();

    Q_INVOKABLE void save() const;

    ProductModel *productModel() const;
    SelectedProductProxyModel *selectedProductModel() const;

signals:
    void saleReceived(bool result);
    void saleStatusReceived(bool result);

public slots:
    void sale();
    void getSaleStatus();

private slots:
    void receiveSale(int result);
    void receiveSaleStatus(int result, int saleStatus);

private:
    GraftPOSAPI *mApi;
    PatrickQRCodeEncoder *mQRCodeEncoder;
    QString mPID;
    ProductModel *mProductModel;
    SelectedProductProxyModel *mSelectedProductModel;
};

#endif // GRAFTPOSCLIENT_H
