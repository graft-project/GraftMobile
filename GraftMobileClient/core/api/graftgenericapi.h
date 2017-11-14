#ifndef GRAFTGENERICAPI_H
#define GRAFTGENERICAPI_H

#include <QNetworkRequest>
#include <QElapsedTimer>
#include <QObject>

class QNetworkAccessManager;
class QNetworkReply;

class GraftGenericAPI : public QObject
{
    Q_OBJECT
public:
    enum OperationStatus
    {
        StatusApproved = 0,
        StatusProcessing = 1,
        StatusRejected =  2
    };

    explicit GraftGenericAPI(const QUrl &url, QObject *parent = nullptr);
    virtual ~GraftGenericAPI();
    void setUrl(const QUrl &url);

signals:
    void error();

protected:
    QJsonObject processReply();

    QNetworkAccessManager *mManager;
    QNetworkRequest mRequest;
    QNetworkReply *mReply;
    QElapsedTimer mTimer;
};

#endif // GRAFTGENERICAPI_H
