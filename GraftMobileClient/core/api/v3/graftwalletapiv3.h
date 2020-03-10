#ifndef GRAFTWALLETAPIV3_H
#define GRAFTWALLETAPIV3_H

#include "graftgenericapiv3.h"

class GraftWalletAPIv3 : public GraftGenericAPIv3
{
    Q_OBJECT
public:
    explicit GraftWalletAPIv3(const QStringList &addresses, const QString &dapiVersion,
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

#endif // GRAFTWALLETAPIv3_H
