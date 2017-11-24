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

    explicit GraftClientTools(QObject *parent = nullptr);
};

#endif // GRAFTCLIENTTOOLS_H
