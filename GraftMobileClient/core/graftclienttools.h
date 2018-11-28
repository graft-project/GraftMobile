#ifndef GRAFTCLIENTTOOLS_H
#define GRAFTCLIENTTOOLS_H

#include <QObject>

class GraftClientTools : public QObject
{
    Q_OBJECT
public:
    enum BalanceTypes {
        LockedBalance = 0,
        UnlockedBalance,
        LocalBalance
    };
    Q_ENUM(BalanceTypes)

    enum NetworkConfiguration
    {
        Mainnet = 0,
        PublicTestnet,
        PublicExperimentalTestnet
    };
    Q_ENUM(NetworkConfiguration)

    enum NetworkType
    {
        Http = 0,
        Https,
        None
    };
    Q_ENUM(NetworkType)

    explicit GraftClientTools(QObject *parent = nullptr);

    Q_INVOKABLE static bool isValidIp(const QString &ip);
    Q_INVOKABLE static bool isValidUrl(const QString &urlAddress);

    Q_INVOKABLE static QString wideSpacingSimplify(const QString &seed);

    Q_INVOKABLE static void copyToClipboard(const QString &data);

    Q_INVOKABLE static QString dotsRemove(const QString &message);

    Q_INVOKABLE static NetworkType networkType(const QString &text);
};

#endif // GRAFTCLIENTTOOLS_H
