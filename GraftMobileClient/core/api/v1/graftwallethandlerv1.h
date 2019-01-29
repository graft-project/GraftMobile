#ifndef GRAFTWALLETHANDLERV1_H
#define GRAFTWALLETHANDLERV1_H

#include "../graftwallethandler.h"

class GraftWalletAPIv1;

class GraftWalletHandlerV1 : public GraftWalletHandler
{
    Q_OBJECT
public:
    explicit GraftWalletHandlerV1(const QString &dapiVersion, const QStringList addresses,
                                  QObject *parent = nullptr);

    void changeAddresses(const QStringList &addresses,
                         const QStringList &internalAddresses = QStringList()) override;

    void setAccountData(const QByteArray &accountData, const QString &password) override;
    QByteArray accountData() const override;
    QString password() const override;

    void resetData() override;

public slots:
    void createAccount(const QString &password) override;
    void restoreAccount(const QString &seed, const QString &password) override;
    void updateBalance() override;
    void transferFee(const QString &address, const QString &amount,
                     const QString &paymentID = QString()) override;
    void transfer(const QString &address, const QString &amount,
                  const QString &paymentID = QString()) override;

    void saleDetails(const QString &pid, int blockNumber) override;
    void rejectPay(const QString &pid, int blockNumber) override;
    void pay(const QString &pid, const QString &address, double amount, int blockNumber) override;
    void payStatus(const QString &pid, int blockNumber) override;

private slots:
    void receiveRejectPay(int result);
    void receivePayStatus(int result, int status);
    void receiveBalance(double balance, double unlockedBalance);
    void receiveTransferFee(int result, double fee);
    void receiveTransfer(int result);

private:
    GraftWalletAPIv1 *mApi;
    QString mLastPID;
    int mBlockNumber;
};

#endif // GRAFTWALLETHANDLERV1_H
