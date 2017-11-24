#ifndef GRAFTBASECLIENT_H
#define GRAFTBASECLIENT_H

#include <QObject>
#include <QVariant>

class BarcodeImageProvider;
class QuickExchangeModel;
class GraftGenericAPI;
class AccountManager;
class CurrencyModel;
class AccountModel;
class QQmlEngine;
class QSettings;

class GraftBaseClient : public QObject
{
    Q_OBJECT
public:
    enum BalanceTypes {
        LockedBalance,
        UnlockedBalance,
        LocalBalance
    };
    Q_ENUM(BalanceTypes)

    explicit GraftBaseClient(QObject *parent = nullptr);
    virtual ~GraftBaseClient();

    AccountModel *accountModel() const;
    CurrencyModel *currencyModel() const;
    QuickExchangeModel *quickExchangeModel() const;

    void setQRCodeImage(const QImage &image);
    virtual void registerTypes(QQmlEngine *engine);

    Q_INVOKABLE QString qrCodeImage() const;

    Q_INVOKABLE void saveSettings() const;
    Q_INVOKABLE QVariant settings(const QString &key) const;
    Q_INVOKABLE void setSettings(const QString &key, const QVariant &value);
    Q_INVOKABLE bool useOwnServiceAddress() const;
    virtual bool resetUrl(const QString &ip, const QString &port);
    bool isValidIp(const QString &ip) const;

    Q_INVOKABLE double balance(BalanceTypes type) const;

    void updateQuickExchange(double cost);

signals:
    void errorReceived(const QString &message);
    void balanceUpdated();

public slots:
    void saveAccounts() const;

protected:
    void timerEvent(QTimerEvent *event) override;

    void registerImageProvider(QQmlEngine *engine);
    void saveModel(const QString &fileName,const QByteArray &data) const;
    QByteArray loadModel(const QString &fileName) const;
    QUrl getServiceUrl() const;
    void requestAccount(GraftGenericAPI *api);
    void registerBalanceTimer(GraftGenericAPI *api);
    virtual void updateBalance() = 0;

    BarcodeImageProvider *mImageProvider;
    AccountModel *mAccountModel;
    CurrencyModel *mCurrencyModel;
    QuickExchangeModel *mQuickExchangeModel;
    QSettings *mClientSettings;
    AccountManager *mAccountManager;

    QMap<int, double> mBalances;

private slots:
    void receiveAccount(const QByteArray &accountData, const QString &password);
    void receiveBalance(double balance, double unlockedBalance);

private:
    void initSettings();
    void initAccountModel(QQmlEngine *engine);
    void initCurrencyModel(QQmlEngine *engine);
    void initQuickExchangeModel(QQmlEngine *engine);

    int mBalanceTimer;
};

#endif // GRAFTBASECLIENT_H
