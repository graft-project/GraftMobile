#ifndef GRAFTBASEHANDLER_H
#define GRAFTBASEHANDLER_H

#include <QObject>

class QNetworkAccessManager;
class TransactionInfo;

class GraftBaseHandler : public QObject
{
    Q_OBJECT
public:
    explicit GraftBaseHandler(QObject *parent = nullptr)
        : QObject(parent)
        ,mManager{nullptr}
    {}

    virtual void changeAddresses(const QStringList &addresses,
                                 const QStringList &internalAddresses = QStringList()) = 0;

    virtual void setAccountData(const QByteArray &accountData, const QString &password) = 0;
    virtual QByteArray accountData() const = 0;
    virtual QString password() const = 0;

    virtual void resetData() = 0;

    virtual void setNetworkManager(QNetworkAccessManager *networkManager)
    {
        if (networkManager && mManager != networkManager)
        {
            mManager = networkManager;
        }
    }

public slots:
    virtual void createAccount(const QString &password) = 0;
    virtual void restoreAccount(const QString &seed, const QString &password) = 0;
    virtual void updateBalance() = 0;
    virtual void updateTransactionHistory() = 0;
    virtual void transferFee(const QString &address, const QString &amount,
                             const QString &paymentID = QString()) = 0;
    virtual void transfer(const QString &address, const QString &amount,
                          const QString &paymentID = QString()) = 0;

signals:
    void errorReceived(const QString &message);
    void createAccountReceived(const QByteArray &accountData, const QString &password,
                               const QString &address, const QString &viewKey, const QString &seed);
    void restoreAccountReceived(const QByteArray &accountData, const QString &password,
                                const QString &address, const QString &viewKey,
                                const QString &seed);
    void balanceReceived(double balance, double unlockedBalance);
    void transferFeeReceived(bool result, double fee);
    void transferReceived(bool result);
    void transactionHistoryReceived(const QList<TransactionInfo*> &tx_history);

protected:
    QNetworkAccessManager *mManager;
};

#endif // GRAFTBASEHANDLER_H
