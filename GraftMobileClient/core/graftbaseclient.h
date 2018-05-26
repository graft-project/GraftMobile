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
    explicit GraftBaseClient(QObject *parent = nullptr);
    virtual ~GraftBaseClient();

    Q_INVOKABLE void setNetworkType(int networkType);
    Q_INVOKABLE int networkType() const;
    Q_INVOKABLE bool isAccountExists() const;
    Q_INVOKABLE void resetData();

    Q_INVOKABLE void createAccount(const QString &password);
    Q_INVOKABLE void restoreAccount(const QString &seed, const QString &password);
    Q_INVOKABLE void transfer(const QString &address, const QString &amount);
    Q_INVOKABLE void transferFee(const QString &address, const QString &amount);

    Q_INVOKABLE QString getSeed() const;
    Q_INVOKABLE QString address() const;

    AccountModel *accountModel() const;
    CurrencyModel *currencyModel() const;
    QuickExchangeModel *quickExchangeModel() const;

    void setQRCodeImage(const QImage &image);
    virtual void registerTypes(QQmlEngine *engine);

    Q_INVOKABLE QString qrCodeImage() const;
    Q_INVOKABLE QString addressQRCodeImage() const;
    Q_INVOKABLE QString coinAddressQRCodeImage(const QString &address) const;

    Q_INVOKABLE void saveSettings() const;
    Q_INVOKABLE void removeSettings() const;
    Q_INVOKABLE QVariant settings(const QString &key) const;
    Q_INVOKABLE void setSettings(const QString &key, const QVariant &value) const;
    Q_INVOKABLE bool useOwnServiceAddress() const;
    Q_INVOKABLE bool resetUrl(const QString &ip, const QString &port);
    Q_INVOKABLE bool isValidIp(const QString &ip) const;

    Q_INVOKABLE double balance(int type) const;
    void saveBalance() const;

    void updateQuickExchange(double cost);

    Q_INVOKABLE bool checkPassword(const QString &password) const;
    Q_INVOKABLE void copyToClipboard(const QString &data) const;

    Q_INVOKABLE QString networkName() const;
    Q_INVOKABLE QString dapiVersion() const;
    QStringList seedSupernodes() const;

    Q_INVOKABLE QString wideSpacingSimplify(const QString &seed) const;
    Q_INVOKABLE bool isBalanceUpdated() const;

    Q_INVOKABLE QString versionNumber() const;

signals:
    void errorReceived(const QString &message);
    void balanceUpdated();
    void createAccountReceived(bool isAccountCreated);
    void restoreAccountReceived(bool isAccountRestored);
    void transferReceived(bool result);
    void transferFeeReceived(bool result, double fee);
    void networkTypeChanged();

public slots:
    void saveAccounts() const;
    void updateBalance();

protected:
    void timerEvent(QTimerEvent *event) override;

    virtual GraftGenericAPI *graftAPI() const = 0;

    void initAccountSettings();
    void registerImageProvider(QQmlEngine *engine);
    void saveModel(const QString &fileName,const QByteArray &data) const;
    QByteArray loadModel(const QString &fileName) const;
    QStringList getServiceAddresses() const;

private slots:
    void receiveAccount(const QByteArray &accountData, const QString &password,
                        const QString &address, const QString &viewKey,
                        const QString &seed);
    void receiveRestoreAccount(const QByteArray &accountData, const QString &password,
                               const QString &address, const QString &viewKey,
                               const QString &seed);
    void receiveBalance(double balance, double unlockedBalance);
    void receiveTransfer(int result);
    void receiveTransferFee(int result, double fee);

private:
    void initSettings();
    void initAccountModel(QQmlEngine *engine);
    void initCurrencyModel(QQmlEngine *engine);
    void initQuickExchangeModel(QQmlEngine *engine);
    void updateAddressQRCode() const;

protected:
    BarcodeImageProvider *mImageProvider;
    AccountModel *mAccountModel;
    CurrencyModel *mCurrencyModel;
    QuickExchangeModel *mQuickExchangeModel;
    AccountManager *mAccountManager;
    QSettings *mClientSettings;

    QMap<int, double> mBalances;

private:
    int mBalanceTimer;
    bool mIsBalanceUpdated;
};

#endif // GRAFTBASECLIENT_H
