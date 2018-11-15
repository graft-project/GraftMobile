#ifndef GRAFTWALLET_H
#define GRAFTWALLET_H

#include <QObject>

#include "wallet2_api.h"

class GraftWallet : public QObject
{
    Q_OBJECT
public:
    explicit GraftWallet(QObject *parent = nullptr);
    ~GraftWallet();

    void setTestnet(bool t);
    bool isTestnet() const;

    void changeAddresses(const QStringList &addresses);

    bool createWallet(const QString &password);
    bool restoreWallet(const QString &seed, const QString &password);
    bool restoreWallet(const QByteArray &data, const QString &password);

    QString seed() const;
    QString publicAddress() const;
    QByteArray accountData() const;

    QString publicViewKey() const;
    QString privateViewKey() const;
    QString publicSpendKey() const;
    QString privateSpendKey() const;

    uint64_t balance() const;
    uint64_t unlockedBalance() const;
    uint64_t lockedBalance() const;

    bool prepareTransaction(const QString &address, uint64_t amount);
    bool prepareTransactionAsync(const QString &address, uint64_t amount);
    bool prepareRTATransaction(const QVector<QPair<QString, uint64_t> > &addresses);
    bool prepareRTATransactionAsync(const QVector<QPair<QString, uint64_t> > &addresses);
    uint64_t currentTransactionFee() const;
    bool sendCurrentTransaction();
    void cacheCurrentTransaction();
    void closeCurrentTransaction();

    QByteArrayList getRawCurrentTransaction() const;
    QByteArrayList getRawTransaction(const QString &address, uint64_t amount);
    QByteArrayList getRawTransaction(const QVector<QPair<QString, uint64_t> > &addresses);

    void startRefresh();

    void saveCache() const;
    bool removeCache() const;

    void closeWallet();

    void updateWallet();
    void refreshWallet();

    QString lastError() const;

signals:
    void updated();
    void refreshed();
    void transactionPrepared(bool result);
    void rtaTransactionPrepared(bool result);

private:
    QString nextAddress();
    QString cacheFilePath() const;

    bool mTestnet;
    Monero::WalletManager *mManager;
    Monero::Wallet *mWallet;
    Monero::WalletListener *mListener;
    Monero::PendingTransaction *mCurrentTransaction;

    QString mLastError;
    QStringList mAddresses;
    int mCurrentAddress;
};

#endif // GRAFTWALLET_H
