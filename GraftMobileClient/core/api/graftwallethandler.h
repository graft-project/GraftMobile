#ifndef GRAFTWALLETHANDLER_H
#define GRAFTWALLETHANDLER_H

#include "graftbasehandler.h"

class GraftWalletHandler : public GraftBaseHandler
{
    Q_OBJECT
public:
    explicit GraftWalletHandler(QObject *parent = nullptr) : GraftBaseHandler(parent) {}

public slots:
    virtual void saleDetails(const QString &pid, int blockNumber) = 0;
    virtual void rejectPay(const QString &pid, int blockNumber) = 0;
    virtual void pay(const QString &pid, const QString &address,
                     double amount, int blockNumber) = 0;
    virtual void payStatus(const QString &pid, int blockNumber) = 0;

signals:
    void saleDetailsReceived(int result, const QString &details);
    void payReceived(int result);
    void rejectPayReceived(bool result);
    void payStatusReceived(bool result);
};

#endif // GRAFTWALLETHANDLER_H
