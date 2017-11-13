#ifndef GRAFTBASECLIENT_H
#define GRAFTBASECLIENT_H

#include <QObject>
#include <QVariant>

class BarcodeImageProvider;
class QuickExchangeModel;
class QQmlEngine;
class QSettings;

class GraftBaseClient : public QObject
{
    Q_OBJECT
public:
    explicit GraftBaseClient(QObject *parent = nullptr);

    void setQRCodeImage(const QImage &image);
    Q_INVOKABLE QString qrCodeImage() const;

    void registerImageProvider(QQmlEngine *engine);

    QuickExchangeModel *quickExchangeModel() const;

    void initSettings();
    Q_INVOKABLE void saveSettings() const;
    Q_INVOKABLE QVariant settings(const QString &key) const;
    Q_INVOKABLE void setSettings(const QString &key, const QVariant &value);

signals:
    void errorReceived();

protected:
    BarcodeImageProvider *mImageProvider;
    QuickExchangeModel *mQuickExchangeModel;
    QSettings *mClientSettings;
};

#endif // GRAFTBASECLIENT_H
