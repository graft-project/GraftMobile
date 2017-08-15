#ifndef GRAFTWALLETCLIENT_H
#define GRAFTWALLETCLIENT_H

#include <QObject>

class GraftWalletAPI;

class GraftWalletClient : public QObject
{
    Q_OBJECT
public:
    explicit GraftWalletClient(QObject *parent = nullptr);

signals:
    void readyToPayReceived(bool result);
    void rejectPayReceived(bool result);
    void payReceived(bool result);
    void payStatusReceived(bool result);
    void errorReceived();

public slots:
    void readyToPay(const QString &data);
    void rejectPay();
    void pay();
    void getPayStatus();

private slots:
    void receiveReadyToPay(int result, const QString &transaction);
    void receiveRejectPay(int result);
    void receivePay(int result);
    void receivePayStatus(int result, int payStatus);

private:
    GraftWalletAPI *mApi;
    QString mPID;
    QString mPrivateKey;
};

#endif // GRAFTWALLETCLIENT_H
