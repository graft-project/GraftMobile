#ifndef GRAFTPOSHANDLERV2_H
#define GRAFTPOSHANDLERV2_H

#include "../graftposhandler.h"

class GraftPOSAPIv2;
class GraftWallet;

class GraftPOSHandlerV2 : public GraftPOSHandler
{
    Q_OBJECT
public:
    explicit GraftPOSHandlerV2(const QString &dapiVersion, const QStringList &addresses,
                               const QStringList &internalAddresses, bool testnet = false,
                               QObject *parent = nullptr);

    void changeAddresses(const QStringList &addresses,
                         const QStringList &internalAddresses = QStringList()) override;

    void setAccountData(const QByteArray &accountData, const QString &password) override;
    void setNetworkManager(QNetworkAccessManager *networkManager) override;
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

    void sale(const QString &address, const QString &viewKey, double amount,
              const QString &saleDetails = QString()) override;
    void rejectSale(const QString &pid) override;
    void saleStatus(const QString &pid, int blockNumber) override;

private slots:
    void receiveBalance();
    void receiveTransaction(bool result);
    void receiveSale(const QString &pid, int blockNumber);
    void receiveRejectSale(int result);
    void receiveSaleStatus(int status);

private:
    GraftWallet *mWallet;
    GraftPOSAPIv2 *mApi;
    QString mLastPID;
    int mBlockNumber;
    //TODO: Temporary
    bool tRetryStatus;
};

#endif // GRAFTPOSHANDLERV2_H
