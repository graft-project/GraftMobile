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
    explicit GraftBaseClient(QQmlEngine *engine, QObject *parent = nullptr);

    void setQRCodeImage(const QImage &image);
    Q_INVOKABLE QString qrCodeImage() const;

    QuickExchangeModel *quickExchangeModel() const;

    void registerImageProvider(QQmlEngine *engine);

signals:
    void errorReceived();

private:
    void initAccountModel (QQmlEngine *engine);
    void initCurrencyModel(QQmlEngine *engine);

protected:
    BarcodeImageProvider *mImageProvider;
    QuickExchangeModel *mQuickExchangeModel;
    AccountModel *mAccountModel;
    CurrencyModel *mCurrencyModel;
};

#endif // GRAFTBASECLIENT_H
