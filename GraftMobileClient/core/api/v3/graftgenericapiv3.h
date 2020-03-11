#ifndef GRAFTGENERICAPIV3_H
#define GRAFTGENERICAPIV3_H

#include <QNetworkRequest>
#include <QElapsedTimer>
#include <QJsonObject>
#include <QObject>

class QNetworkAccessManager;
class QNetworkReply;
class QJsonArray;

class GraftGenericAPIv3 : public QObject
{
    Q_OBJECT
public:
    // copy-pasted from graft-ng/
    enum OperationStatus
    {
        None = 0,
        InProgress = 2,    // non-continous (compatibility issues)
        Success = 3,
        FailRejectedByPOS, // rejected by PoS
        FailZeroFee,       // rejected by auth sample due low or zero fee
        FailDoubleSpend,   // rejected by auth sample due double spend
        FailTimedOut,      // timed out
        FailTxRejected     // tx rejected by cryptonode
        
    };
    
    // TODO: reuse structures/serialization from graft-ng?
    struct NodeAddress 
    {
        NodeAddress() {}
        QString Id;
        QString WalletAddress;
        static NodeAddress fromJson(const QJsonObject &arg);
        QJsonObject toJson() const;
    };
    
    struct NodeId
    {
        NodeId() {}
        QString Id;
        static NodeId fromJson(const QJsonObject &arg);
        QJsonObject toJson() const;
    };
    
    struct PaymentData 
    {
        QString EncryptedPayment;
        QList<NodeId> AuthSampleKeys;
        NodeAddress PosProxy;
        static PaymentData fromJson(const QJsonObject &arg);
        QJsonObject toJson() const;
    };
    

    explicit GraftGenericAPIv3(const QStringList &addresses, const QString &dapiVersion,
                               QObject *parent = nullptr);
    virtual ~GraftGenericAPIv3();

    void changeAddresses(const QStringList &addresses);
    void setDAPIVersion(const QString &version);

    void setAccountData(const QByteArray &accountData, const QString &password);
    QByteArray accountData() const;
    QString password() const;

    void createAccount(const QString &password);
    void getBalance();
    void getTransactionHistory(quint64 fromBlock);
    void getSeed();
    void restoreAccount(const QString &seed, const QString &password);
    void transferFee(const QString &address, const QString &amount,
                     const QString &paymentID = QString());
    void transfer(const QString &address, const QString &amount,
                  const QString &paymentID = QString());

    static double toCoins(double atomic);
    static double toAtomic(double coins);

    void setNetworkManager(QNetworkAccessManager *networkManager);

signals:
    void error(const QString &message);
    void createAccountReceived(const QByteArray &accountData, const QString &password,
                               const QString &address, const QString &viewKey, const QString &seed);
    void balanceReceived(double balance, double unlockedBalance);
    void getSeedReceived(const QString &seed);
    void restoreAccountReceived(const QByteArray &accountData, const QString &password,
                                const QString &address, const QString &viewKey,
                                const QString &seed);
    void transferFeeReceived(int result, double fee);
    void transferReceived(int result);
    void transactionHistoryReceived(const QJsonArray &txOut, const QJsonArray &txIn, const QJsonArray &txPending,
                                    const QJsonArray &txFailed, const QJsonArray &txPool);

protected:
    QString accountPlaceholder() const;
    QByteArray serializeAmount(double amount) const;
    QJsonObject buildMessage(const QString &key, const QJsonObject &params = QJsonObject()) const;
    QJsonObject processReply(QNetworkReply *reply);
    bool processReplyRest(QNetworkReply *reply, int &httpStatus, QJsonObject &response);
    QUrl nextAddress(const QString &endpoint = QString());
    QNetworkReply *retry();

private slots:
    void receiveCreateAccountResponse();
    void receiveGetBalanceResponse();
    void receiveGetSeedResponse();
    void receiveRestoreAccountResponse();
    void receiveTransferFeeResponse();
    void receiveTransferResponse();
    void receiveGetTransactionsResponse();

protected:
    QNetworkAccessManager *mManager;
    QNetworkRequest mRequest;
    QElapsedTimer mTimer;
    QStringList mAddresses;
    int mCurrentAddress;

    QByteArray mAccountData;
    QString mPassword;

    QString mDAPIVersion;

    QString mLastError;
    int mRetries;
    QByteArray mLastRequest;
};

#endif // GRAFTGENERICAPIV3_H
