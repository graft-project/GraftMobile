#ifndef GRAFTPOSHANDLER_H
#define GRAFTPOSHANDLER_H

#include "graftbasehandler.h"

class GraftPOSHandler : public GraftBaseHandler
{
    Q_OBJECT
public:
    explicit GraftPOSHandler(QObject *parent = nullptr) : GraftBaseHandler(parent) {}

public slots:
    virtual void sale(const QString &address, const QString &viewKey, double amount,
                      const QString &saleDetails = QString()) = 0;
    virtual void rejectSale(const QString &pid) = 0;
    virtual void saleStatus(const QString &pid, int blockNumber) = 0;

signals:
    void saleReceived(int result, const QString &pid, int blockNumber);
    void rejectSaleReceived(bool result);
    void saleStatusReceived(bool result);
};

#endif // GRAFTPOSHANDLER_H
