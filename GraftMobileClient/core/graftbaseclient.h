#ifndef GRAFTBASECLIENT_H
#define GRAFTBASECLIENT_H

#include <QObject>

class BarcodeImageProvider;
class QuickExchangeModel;
class AccountModel;
class CurrencyModel;
class QQmlEngine;

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

signals:
    void errorReceived();

public slots:
    void saveAccount();

protected:
    BarcodeImageProvider *mImageProvider;
    AccountModel *mAccountModel;
    CurrencyModel *mCurrencyModel;
    QuickExchangeModel *mQuickExchangeModel;

    void registerImageProvider(QQmlEngine *engine);
    void saveModels(QString fileName, QByteArray data);

private:
    void initAccountModel(QQmlEngine *engine);
    void initCurrencyModel(QQmlEngine *engine);
    void initQuickExchangeModel(QQmlEngine *engine);
};

#endif // GRAFTBASECLIENT_H
