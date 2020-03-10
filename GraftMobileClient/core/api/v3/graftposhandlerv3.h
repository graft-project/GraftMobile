#ifndef GRAFTPOSHANDLERV3_H
#define GRAFTPOSHANDLERV3_H

#include "../graftposhandler.h"

class GraftPOSAPIv3;


class GraftPOSHandlerV3 : public GraftPOSHandler
{
    Q_OBJECT
public:
    explicit GraftPOSHandlerV3(const QString &dapiVersion, const QStringList addresses,
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
    void updateTransactionHistory() override;

private slots:
    void receiveRejectSale(int result);
    void receiveSaleStatus(int result, int status);
    void receiveBalance(double balance, double unlockedBalance);
    void receiveTransferFee(int result, double fee);
    void receiveTransfer(int result);

private:
    GraftPOSAPIv3 *mApi;
    QString mLastPID;
};

#endif // GRAFTPOSHANDLERV3_H
