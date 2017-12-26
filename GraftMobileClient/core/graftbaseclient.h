#ifndef GRAFTBASECLIENT_H
#define GRAFTBASECLIENT_H

#include <QObject>
#include <QVariant>
#include "graftclienttools.h"

class BarcodeImageProvider;
class QuickExchangeModel;
class GraftGenericAPI;
class QRCodeGenerator;
class AccountManager;
class CurrencyModel;
class AccountModel;
class QQmlEngine;
class QSettings;

class GraftBaseClient : public QObject
{
    Q_OBJECT
public:
    explicit GraftBaseClient(QObject *parent = nullptr);
    virtual ~GraftBaseClient();

    bool isAccountExists() const;

    virtual void createAccount(const QString &password) = 0;
    virtual void restoreAccount(const QString &seed, const QString &password) = 0;

    Q_INVOKABLE QString getSeed() const;
    Q_INVOKABLE QString address() const;

    AccountModel *accountModel() const;
    CurrencyModel *currencyModel() const;
    QuickExchangeModel *quickExchangeModel() const;

    void setQRCodeImage(const QImage &image);
    virtual void registerTypes(QQmlEngine *engine);

    Q_INVOKABLE QString qrCodeImage() const;
    Q_INVOKABLE QString addressQRCodeImage();
    Q_INVOKABLE QString coinAddressQRCodeImage(QString address);

    Q_INVOKABLE void saveSettings() const;
    Q_INVOKABLE QVariant settings(const QString &key) const;
    Q_INVOKABLE void setSettings(const QString &key, const QVariant &value);
    Q_INVOKABLE bool useOwnServiceAddress() const;
    virtual bool resetUrl(const QString &ip, const QString &port);
    bool isValidIp(const QString &ip) const;

    Q_INVOKABLE double balance(int type) const;

    void updateQuickExchange(double cost);

    Q_INVOKABLE bool checkPassword(const QString &password) const;

signals:
    void errorReceived(const QString &message);
    void balanceUpdated();
    void createAccountReceived();
    void restoreAccountReceived();

public slots:
    void saveAccounts() const;

protected:
    void timerEvent(QTimerEvent *event) override;

    void registerImageProvider(QQmlEngine *engine);
    void saveModel(const QString &fileName,const QByteArray &data) const;
    QByteArray loadModel(const QString &fileName) const;
    QUrl getServiceUrl() const;
    void requestAccount(GraftGenericAPI *api, const QString &password);
    void requestRestoreAccount(GraftGenericAPI *api, const QString &seed, const QString &password);

    void registerBalanceTimer(GraftGenericAPI *api);
    virtual void updateBalance() = 0;

private slots:
    void receiveAccount(const QByteArray &accountData, const QString &password,
                        const QString &address, const QString &viewKey,
                        const QString &seed);
    void receiveRestoreAccount(const QByteArray &accountData, const QString &password,
                               const QString &address, const QString &viewKey,
                               const QString &seed);
    void receiveBalance(double balance, double unlockedBalance);

private:
    void initSettings();
    void initAccountModel(QQmlEngine *engine);
    void initCurrencyModel(QQmlEngine *engine);
    void initQuickExchangeModel(QQmlEngine *engine);
    void updateAddressQRCode();

protected:
    BarcodeImageProvider *mImageProvider;
    QRCodeGenerator *mQRCodeEncoder;
    AccountModel *mAccountModel;
    CurrencyModel *mCurrencyModel;
    QuickExchangeModel *mQuickExchangeModel;
    AccountManager *mAccountManager;
    QSettings *mClientSettings;

    QMap<int, double> mBalances;

private:
    int mBalanceTimer;
};

#endif // GRAFTBASECLIENT_H
