#ifndef ABSTRACTDEVICETOOLS_H
#define ABSTRACTDEVICETOOLS_H

#include <QObject>

class QNetworkAccessManager;

class AbstractDeviceTools : public QObject
{
    Q_OBJECT
public:
    explicit AbstractDeviceTools(QObject *parent = nullptr);
    virtual ~AbstractDeviceTools();

    void setNetworkManager(QNetworkAccessManager *networkManager);

    virtual bool isSpecialTypeDevice() const = 0;

    virtual double bottomNavigationBarHeight() const = 0;
    virtual double statusBarHeight() const = 0;

    virtual void checkAppVersion() const = 0;

signals:
    void updateNeeded(const QString &updateLink, const QString &newVersion) const;

protected:
    QNetworkAccessManager *mNetworkManager;
};

#endif // ABSTRACTDEVICETOOLS_H
