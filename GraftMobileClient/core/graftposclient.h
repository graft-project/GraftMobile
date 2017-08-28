#ifndef GRAFTPOSCLIENT_H
#define GRAFTPOSCLIENT_H

#include "graftbaseclient.h"

class PatrickQRCodeEncoder;
class ProductModel;
class GraftPOSAPI;

class GraftPOSClient : public GraftBaseClient
{
    Q_OBJECT
public:
    explicit GraftPOSClient(QObject *parent = nullptr);
    ~GraftPOSClient();

    ProductModel *productModel() const;

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
};

#endif // GRAFTPOSCLIENT_H
