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
    void rejectPayReceived(int result);
    void payReceived(int result);
    void payStatusReceived(int result, int status);
};

#endif // GRAFTWALLETHANDLER_H
