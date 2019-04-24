#ifndef GRAFTGENERICAPIV2_H
#define GRAFTGENERICAPIV2_H

#include <QNetworkRequest>
#include <QElapsedTimer>
#include <QJsonObject>
#include <QObject>

class QNetworkAccessManager;
class QNetworkReply;

class GraftGenericAPIv2 : public QObject
{
    Q_OBJECT
public:
    enum OperationStatus
    {
        StatusNone = 0,
        StatusWaiting = 1,
        StatusProcessing = 2,
        StatusSuccess = 3,
        StatusFailed =  4,
        StatusWalletRejected = 5,
        StatusPOSRejected = 6
    };

    explicit GraftGenericAPIv2(const QStringList &addresses, const QString &dapiVersion,
                               QObject *parent = nullptr);
    virtual ~GraftGenericAPIv2();

    void changeAddresses(const QStringList &addresses);
    void setDAPIVersion(const QString &version);

    void setAccountData(const QByteArray &accountData, const QString &password);
    QByteArray accountData() const;
    QString password() const;

    static double toCoins(double atomic);
    static double toCoins(uint64_t atomic);
    static double toAtomic(double coins);
    static uint64_t toAtomic(const QString &coins);

    QNetworkAccessManager *networkManager() const;

signals:
    void error(const QString &message);

protected:
    QString accountPlaceholder() const;
    QByteArray serializeAmount(double amount) const;
    QJsonObject buildMessage(const QString &key, const QJsonObject &params = QJsonObject()) const;
    QJsonObject processReply(QNetworkReply *reply);
    QUrl nextAddress(const QString &endpoint = QString());
    QNetworkReply *retry();

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

#endif // GRAFTGENERICAPIV2_H
