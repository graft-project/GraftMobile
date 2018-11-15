#ifndef GRAFTWALLETAPIV1_H
#define GRAFTWALLETAPIV1_H

#include "graftgenericapiv1.h"

class GraftWalletAPIv1 : public GraftGenericAPIv1
{
    Q_OBJECT
public:
    explicit GraftWalletAPIv1(const QStringList &addresses, const QString &dapiVersion,
                              QObject *parent = nullptr);

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

#endif // GRAFTWALLETAPIV1_H
