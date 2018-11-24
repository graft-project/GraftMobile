#ifndef GRAFTCLIENTCONSTANTS_H
#define GRAFTCLIENTCONSTANTS_H

#include <QObject>

class GraftClientConstants : public QObject
{
    Q_OBJECT
public:
    explicit GraftClientConstants(QObject *parent = nullptr);

    Q_INVOKABLE static QString mainnetDescription();
    Q_INVOKABLE static QString publicTestnetDescription();
    Q_INVOKABLE static QString alphaRTATestnetDescription();

    Q_INVOKABLE static QString licenseIntroduction();
    Q_INVOKABLE static QString licenseConditions();

    Q_INVOKABLE static QString invalidCameraPermissionMessage();

    Q_INVOKABLE static QString walletCreated();
};

#endif // GRAFTCLIENTCONSTANTS_H
