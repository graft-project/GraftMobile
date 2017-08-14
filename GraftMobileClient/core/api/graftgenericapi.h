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
    explicit GraftGenericAPI(const QUrl &url, QObject *parent = nullptr);
    virtual ~GraftGenericAPI();

protected:
    QJsonObject processReply();

    QNetworkAccessManager *mManager;
    QNetworkRequest mRequest;
    QNetworkReply *mReply;
    QElapsedTimer mTimer;
};

#endif // GRAFTGENERICAPI_H
