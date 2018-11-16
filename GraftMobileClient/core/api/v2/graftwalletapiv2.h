#ifndef GRAFTWALLETAPIV2_H
#define GRAFTWALLETAPIV2_H

#include "graftgenericapiv2.h"

class GraftWalletAPIv2 : public GraftGenericAPIv2
{
    Q_OBJECT
public:
    explicit GraftWalletAPIv2(const QStringList &addresses, const QString &dapiVersion,
                              QObject *parent = nullptr);

    void saleDetails(const QString &pid, int blockNumber);
    void rejectPay(const QString &pid, int blockNumber);
    void pay(const QString &pid, const QString &address, double amount, int blockNumber,
             const QByteArrayList &transactions);
    void payStatus(const QString &pid, int blockNumber);

signals:
    void saleDetailsReceived(const QVector<QPair<QString, QString>> &authSample,
                             const QString &saleDetails);
    void rejectPayReceived(int result);
    void payReceived(int result);
    void payStatusReceived(int status);

private slots:
    void receiveSaleDetailsResponse();
    void receiveRejectPayResponse();
    void receivePayResponse();
    void receivePayStatusResponse();
};

#endif // GRAFTWALLETAPIV2_H
