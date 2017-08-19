#ifndef GRAFTBASECLIENT_H
#define GRAFTBASECLIENT_H

#include <QObject>
#include <QImage>

class GraftBaseClient : public QObject
{
    Q_OBJECT
public:
    explicit GraftBaseClient(QObject *parent = nullptr);

    void setQRCodeImage(const QImage &image);
    QImage qrCodeImage() const;

signals:
    void errorReceived();
    void updateQRCode();

protected:
    QImage mQRCodeImage;
};

#endif // GRAFTBASECLIENT_H
