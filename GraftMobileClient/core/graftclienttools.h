#ifndef GRAFTCLIENTTOOLS_H
#define GRAFTCLIENTTOOLS_H

#include <QObject>

class GraftClientTools
{
    Q_GADGET
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
};

#endif // GRAFTCLIENTTOOLS_H
