#ifndef GRAFTGENERICAPI_H
#define GRAFTGENERICAPI_H

#include <QNetworkRequest>
#include <QElapsedTimer>
#include <QJsonObject>
#include <QObject>

class QNetworkAccessManager;
class QNetworkReply;

class GraftGenericAPI : public QObject
{
    Q_OBJECT
public:
    enum OperationStatus
    {
        StatusApproved = 0,
        StatusProcessing = 1,
        StatusRejected =  2
    };

    explicit GraftGenericAPI(const QUrl &url, QObject *parent = nullptr);
    virtual ~GraftGenericAPI();

    void setUrl(const QUrl &url);

    void setAccountData(const QByteArray &accountData, const QString &password);
    QByteArray accountData() const;
    QString password() const;

    void createAccount(const QString &password);
    void getBalance();
    void getPaymentAddress(const QString &pid);

    static double toCoins(int atomic);
    static int toAtomic(double coins);

signals:
    void error(const QString &message);
    void createAccountReceived(const QByteArray &accountData, const QString &password);
    void getBalanceReceived(double balance, double unlockedBalance);
    void getPaymentAddressReceived(const QString &address, const QString &pid);

protected:
    QString accountPlaceholder() const;
    QJsonObject buildMessage(const QString &key, const QJsonObject &params = QJsonObject()) const;
    QJsonObject processReply(QNetworkReply *reply);

private slots:
    void receiveCreateAccountResponse();
    void receiveGetBalanceResponse();
    void receiveGetPaymentAddressResponse();

protected:
    QNetworkAccessManager *mManager;
    QNetworkRequest mRequest;
    QElapsedTimer mTimer;

    QByteArray mAccountData;
    QString mPassword;
};

#endif // GRAFTGENERICAPI_H
