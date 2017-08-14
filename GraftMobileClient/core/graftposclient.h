#ifndef GRAFTPOSCLIENT_H
#define GRAFTPOSCLIENT_H

#include <QObject>

class GraftPOSAPI;

class GraftPOSClient : public QObject
{
    Q_OBJECT
public:
    explicit GraftPOSClient(QObject *parent = nullptr);

signals:
    void saleReceived(bool result);
    void saleStatusReceived(bool approved);

public slots:
    void sale();
    void getSaleStatus();

private slots:
    void receiveSale(int result);
    void receiveSaleStatus(int result, int saleStatus);

private:
    GraftPOSAPI *mApi;
    QString mPID;
};

#endif // GRAFTPOSCLIENT_H
