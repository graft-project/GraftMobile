#ifndef GRAFTGENERICAPIV3_H
#define GRAFTGENERICAPIV3_H

#include <QNetworkRequest>
#include <QElapsedTimer>
#include <QJsonObject>
#include <QObject>


#include <crypto/crypto.h>

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
    
    static constexpr int ERROR_INVALID_PAYMENT_ID = -32051;
    
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
    
    struct PaymentStatus
    {
        QString PaymentID;
        uint64_t PaymentBlock = 0;
        int Status = 0;
        QString Signature;
        static PaymentStatus fromJson(const QJsonObject &arg);
        QJsonObject toJson() const;
        void sign(const crypto::public_key &pubkey, const crypto::secret_key &secket);
    };
    
    
    
    struct EncryptedPaymentStatus
    {
        QString PaymentID;
        QString PaymentStatusBlob;
        static EncryptedPaymentStatus fromJson(const QJsonObject &arg);
        QJsonObject toJson() const;
        bool encrypt(const PaymentStatus &ps, const std::vector<crypto::public_key> &keys);
        bool decrypt(const crypto::secret_key &key, PaymentStatus &status);
    };
    
    
    enum NetType
    {
        MAINNET = 0,
        TESTNET
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
    // used in both wallet/pos
    void saleStatus(const QString &pid, int blockNumber);
    

    static double toCoins(double atomic);
    static double toAtomic(double coins);
    static void encryptOneToMany(const std::string &input, const QStringList &keys_serialized, std::string &encryptedHex);
    static void deserializeKeys(const QStringList &serialized_keys, std::vector<crypto::public_key> &keys);

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
    void saleStatusResponseReceived(int status);

protected:
    QString accountPlaceholder() const;
    QByteArray serializeAmount(double amount) const;
    QJsonObject buildMessage(const QString &key, const QJsonObject &params = QJsonObject()) const;
    QJsonObject processReply(QNetworkReply *reply);
    bool processReplyRest(QNetworkReply *reply, int &httpStatus, QJsonObject &response);
    QUrl nextAddress(const QString &endpoint = QString());
    QNetworkReply *retry();
    QNetworkRequest prepareRequest(const QString &endpoint = QString());

private slots:
    void receiveCreateAccountResponse();
    void receiveGetBalanceResponse();
    void receiveGetSeedResponse();
    void receiveRestoreAccountResponse();
    void receiveTransferFeeResponse();
    void receiveTransferResponse();
    void receiveGetTransactionsResponse();
    void receiveSaleStatusResponse();

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
    QString m_paymentId;
};

#endif // GRAFTGENERICAPIV3_H
