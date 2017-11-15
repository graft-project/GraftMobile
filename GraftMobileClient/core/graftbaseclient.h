#ifndef GRAFTBASECLIENT_H
#define GRAFTBASECLIENT_H

#include <QObject>
#include <QVariant>

class BarcodeImageProvider;
class QuickExchangeModel;
class AccountModel;
class CurrencyModel;
class QQmlEngine;
class QSettings;

class GraftBaseClient : public QObject
{
    Q_OBJECT
public:
    explicit GraftBaseClient(QObject *parent = nullptr);

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

signals:
    void errorReceived();

protected:
    BarcodeImageProvider *mImageProvider;
    AccountModel *mAccountModel;
    CurrencyModel *mCurrencyModel;
    QuickExchangeModel *mQuickExchangeModel;
    QSettings *mClientSettings;

    void registerImageProvider(QQmlEngine *engine);
    QUrl getServiceUrl() const;

private:
    void initSettings();
    void initAccountModel(QQmlEngine *engine);
    void initCurrencyModel(QQmlEngine *engine);
    void initQuickExchangeModel(QQmlEngine *engine);
};

#endif // GRAFTBASECLIENT_H
