#ifndef GRAFTWALLETAPI_H
#define GRAFTWALLETAPI_H

#include "graftgenericapi.h"

class GraftWalletAPI : public GraftGenericAPI
{
    Q_OBJECT
public:
    explicit GraftWalletAPI(const QUrl &url, QObject *parent = nullptr);

    void readyToPay(const QString &pid, const QString &keyImage);
    void rejectPay(const QString &pid);
    void pay(const QString &pid, const QString &address, double amount);
    void getPayStatus(const QString &pid);

signals:
    void readyToPayReceived(int result, const QString &transaction);
    void rejectPayReceived(int result);
    void payReceived(int result);
    void getPayStatusReceived(int result, int payStatus);

private slots:
    void receiveReadyToPayResponse();
    void receiveRejectPayResponse();
    void receivePayResponse();
    void receivePayStatusResponse();
};

#endif // GRAFTWALLETAPI_H
