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

    void setQRCodeImage(const QImage &image);
    void registeringTypes(QQmlEngine *engine);

    Q_INVOKABLE QString qrCodeImage() const;

signals:
    void errorReceived();

protected:
    BarcodeImageProvider *mImageProvider;
    AccountModel *mAccountModel;
    CurrencyModel *mCurrencyModel;
    QuickExchangeModel *mQuickExchangeModel;

private:
    void initAccountModel(QQmlEngine *engine);
    void initCurrencyModel(QQmlEngine *engine);
    void initQuickExchangeModel(QQmlEngine *engine);
    void registerImageProvider(QQmlEngine *engine);
};

#endif // GRAFTBASECLIENT_H
