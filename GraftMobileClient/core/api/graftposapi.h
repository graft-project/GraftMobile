#ifndef GRAFTPOSAPI_H
#define GRAFTPOSAPI_H

#include "graftgenericapi.h"

class GraftPOSAPI : public GraftGenericAPI
{
    Q_OBJECT
public:
    explicit GraftPOSAPI(const QUrl &url, const QString &dapiVersion, QObject *parent = nullptr);

    void sale(const QString &address, const QString &viewKey, double amount,
              const QString &saleDetails = QString());
    void rejectSale(const QString &pid);
    void getSaleStatus(const QString &pid);

signals:
    void saleResponseReceived(int result, const QString &pid, int blockNum);
    void rejectSaleResponseReceived(int result);
    void getSaleStatusResponseReceived(int result, int status);

private slots:
    void receiveSaleResponse();
    void receiveRejectSaleResponse();
    void receiveSaleStatusResponse();
};

#endif // GRAFTPOSAPI_H
