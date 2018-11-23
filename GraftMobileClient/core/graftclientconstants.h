#ifndef GRAFTCLIENTCONSTANTS_H
#define GRAFTCLIENTCONSTANTS_H

#include <QObject>

class GraftClientConstants : public QObject
{
    Q_OBJECT
public:
    explicit GraftClientConstants(QObject *parent = nullptr);

    Q_INVOKABLE static QString mainnetDescription();
    Q_INVOKABLE static QString testnetDescription();
    Q_INVOKABLE static QString alphaRTADescription();

    Q_INVOKABLE static QString licensingLets();
    Q_INVOKABLE static QString licenseDescription();

    Q_INVOKABLE static QString cameraPermission();

    Q_INVOKABLE static QString walletCreated();
};

#endif // GRAFTCLIENTCONSTANTS_H
