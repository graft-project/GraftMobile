#ifndef GRAFTPOSAPIV2_H
#define GRAFTPOSAPIV2_H

#include "graftgenericapiv2.h"

class GraftPOSAPIv2 : public GraftGenericAPIv2
{
    Q_OBJECT
public:
    explicit GraftPOSAPIv2(const QStringList &addresses, const QString &dapiVersion,
                           QObject *parent = nullptr);

    void sale(const QString &address, double amount, const QString &saleDetails = QString());
    void rejectSale(const QString &pid);
    void saleStatus(const QString &pid, int blockNumber);

signals:
    void saleResponseReceived(const QString &pid, int blockNumber);
    void rejectSaleResponseReceived(int result);
    void saleStatusResponseReceived(int status);

private slots:
    void receiveSaleResponse();
    void receiveRejectSaleResponse();
    void receiveSaleStatusResponse();
};

#endif // GRAFTPOSAPIV2_H
