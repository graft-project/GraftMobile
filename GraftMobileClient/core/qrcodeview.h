#ifndef QRCODEVIEW_H
#define QRCODEVIEW_H

#include <QQuickPaintedItem>

class GraftBaseClient;

class QRCodeView : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(GraftBaseClient* client READ client WRITE setClient NOTIFY clientChanged)
public:
    explicit QRCodeView(QQuickItem *parent = nullptr);

    void paint(QPainter *painter) override;

    Q_INVOKABLE void setClient(GraftBaseClient *client);
    GraftBaseClient *client() const;

signals:
    void clientChanged();

private slots:
    void updateQRImage();

private:
    GraftBaseClient *mClient;
};

#endif // QRCODEVIEW_H
