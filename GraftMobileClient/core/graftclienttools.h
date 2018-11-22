#ifndef GRAFTCLIENTTOOLS_H
#define GRAFTCLIENTTOOLS_H

#include <QObject>

class GraftClientTools : public QObject
{
    Q_OBJECT
public:
    enum BalanceTypes {
        LockedBalance,
        UnlockedBalance,
        LocalBalance
    };
    Q_ENUM(BalanceTypes)

    enum NetworkConfiguration
    {
        Mainnet = 0,
        PublicTestnet = 1,
        PublicExperimentalTestnet = 2
    };
    Q_ENUM(NetworkConfiguration)

    explicit GraftClientTools(QObject *parent = nullptr);

    Q_INVOKABLE static bool isValidIp(const QString &ip);
    Q_INVOKABLE static bool isValidUrl(const QString &urlAddress);

    Q_INVOKABLE static QString wideSpacingSimplify(const QString &seed);

    Q_INVOKABLE static void copyToClipboard(const QString &data);
};

#endif // GRAFTCLIENTTOOLS_H
