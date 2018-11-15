#ifndef GRAFTWALLETHANDLERV2_H
#define GRAFTWALLETHANDLERV2_H

#include "../graftwallethandler.h"

#include <QVector>

class GraftWalletAPIv2;
class GraftWallet;

class GraftWalletHandlerV2 : public GraftWalletHandler
{
    Q_OBJECT
public:
    explicit GraftWalletHandlerV2(const QString &dapiVersion, const QStringList &addresses,
                                  const QStringList &internalAddresses, bool testnet = false,
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
    void transferFee(const QString &address, const QString &amount) override;
    void transfer(const QString &address, const QString &amount) override;

    void saleDetails(const QString &pid, int blockNumber) override;
    void rejectPay(const QString &pid, int blockNumber) override;
    void pay(const QString &pid, const QString &address, double amount, int blockNumber) override;
    void payStatus(const QString &pid, int blockNumber) override;

private slots:
    void receiveBalance();
    void receiveTransaction(bool result);
    void receiveSaleDetails(const QVector<QPair<QString, QString>> &authSample,
                            const QString &saleDetails);
    void sendPay(bool result);
    void receivePayStatus(int status);
    void processPayResult(bool result);

private:
    GraftWalletAPIv2 *mApi;
    GraftWallet *mWallet;
    QString mLastPID;
    int mBlockNumber;
    QString mPOSAddress;
    double mTotalCost;
    QVector<QPair<QString, QString>> mAuthSample;
};

#endif // GRAFTWALLETHANDLERV2_H
