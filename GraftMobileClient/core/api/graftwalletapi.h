#ifndef GRAFTWALLETAPI_H
#define GRAFTWALLETAPI_H

#include "graftgenericapi.h"

class GraftWalletAPI : public GraftGenericAPI
{
    Q_OBJECT
public:
    explicit GraftWalletAPI(const QUrl &url, const QString &dapiVersion, QObject *parent = nullptr);

    void getPOSData(const QString &pid, int blockNum);
    void rejectPay(const QString &pid, int blockNum);
    void pay(const QString &pid, const QString &address, double amount, int blockNum);
    void getPayStatus(const QString &pid);

signals:
    void getPOSDataReceived(int result, const QString &payDetails);
    void rejectPayReceived(int result);
    void payReceived(int result);
    void getPayStatusReceived(int result, int status);

private slots:
    void receiveGetPOSDataResponse();
    void receiveRejectPayResponse();
    void receivePayResponse();
    void receivePayStatusResponse();
};

#endif // GRAFTWALLETAPI_H
