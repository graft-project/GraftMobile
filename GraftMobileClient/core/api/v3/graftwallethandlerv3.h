#ifndef GRAFTWALLETHANDLERV3_H
#define GRAFTWALLETHANDLERV3_H

#include "../graftwallethandler.h"

class GraftWalletAPIv3;

/*!
 * \brief The GraftPOSHandlerv3 class - what does this class do and what is for?
 */

class GraftWalletHandlerV3 : public GraftWalletHandler
{
    Q_OBJECT
public:
    explicit GraftWalletHandlerV3(const QString &dapiVersion, const QStringList addresses,
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
    void updateTransactionHistory() override;
    void transferFee(const QString &address, const QString &amount,
                     const QString &paymentID = QString()) override;
    void transfer(const QString &address, const QString &amount,
                  const QString &paymentID = QString()) override;

    void saleDetails(const QString &pid, int blockNumber, const QString &blockHash) override;
    void rejectPay(const QString &pid, int blockNumber) override;
    void pay(const QString &pid, const QString &address, double amount, int blockNumber) override;
    void payStatus(const QString &pid, int blockNumber) override;
    void buildRtaTransaction(const QString &pid, const QString &dstAddress, const QStringList &keys, const QStringList &wallets,
                             double amount, double feeRatio, int blockNumber) override;
    void getSupernodeInfo(const QStringList &keys) override;
    void submitRtaTx(const QString &txHex, const QString &txKeyHex) override;

private slots:
    void receiveRejectPay(int result);
    void receivePayStatus(int status);
    void receiveBalance(double balance, double unlockedBalance);
    void receiveTransferFee(int result, double fee);
    void receiveTransfer(int result);
    void receiveTransactionHistory(const QJsonArray &transfersOut, const QJsonArray &transfersIn, const QJsonArray &transfersPending,
                                    const QJsonArray &transfersFailed, const QJsonArray &transfersPool);
    void receiveBuildRtaTransaction(int result, const QString &errorMessage, const QStringList &ptxVector, double recepientAmount, 
                                    double feePerDestination);
    void receiveSupernodeInfo(const QStringList &wallets);

private:
    GraftWalletAPIv3 *mApi;
    QString mLastPID;
    int mBlockNumber;
    quint64 m_lastTxHistoryBlock = 0;
};

#endif // GRAFTWALLETHANDLERV3_H
