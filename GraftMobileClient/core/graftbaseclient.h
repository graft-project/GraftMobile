#ifndef GRAFTBASECLIENT_H
#define GRAFTBASECLIENT_H

#include <QObject>

class BarcodeImageProvider;
class QuickExchangeModel;
class QQmlEngine;

class GraftBaseClient : public QObject
{
    Q_OBJECT
public:
    explicit GraftBaseClient(QObject *parent = nullptr);

    void setQRCodeImage(const QImage &image);
    Q_INVOKABLE QString qrCodeImage() const;

    void registerImageProvider(QQmlEngine *engine);

    QuickExchangeModel *quickExchangeModel();
    void setQuickExchangeModel(QuickExchangeModel *quickExchangeModel);

signals:
    void errorReceived();

protected:
    BarcodeImageProvider *mImageProvider;
    QuickExchangeModel *mQuickExchangeModel;
};

#endif // GRAFTBASECLIENT_H
