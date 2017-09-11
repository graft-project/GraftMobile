#ifndef GRAFTPOSAPI_H
#define GRAFTPOSAPI_H

#include "graftgenericapi.h"

class GraftPOSAPI : public GraftGenericAPI
{
    Q_OBJECT
public:
    explicit GraftPOSAPI(const QUrl &url, QObject *parent = nullptr);

    void sale(const QString &pid, const QString &transaction);
    void rejectSale(const QString &pid);
    void getSaleStatus(const QString &pid);

signals:
    void saleResponseReceived(int result);
    void rejectSaleResponseReceived(int result);
    void getSaleStatusResponseReceived(int result, int saleStatus);

private slots:
    void receiveSaleResponse();
    void receiveRejectSaleResponse();
    void receiveSaleStatusResponse();
};

#endif // GRAFTPOSAPI_H
