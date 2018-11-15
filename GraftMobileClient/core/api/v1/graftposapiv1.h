#ifndef GRAFTPOSAPIV1_H
#define GRAFTPOSAPIV1_H

#include "graftgenericapiv1.h"

class GraftPOSAPIv1 : public GraftGenericAPIv1
{
    Q_OBJECT
public:
    explicit GraftPOSAPIv1(const QStringList &addresses, const QString &dapiVersion,
                           QObject *parent = nullptr);

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

#endif // GRAFTPOSAPIV1_H
