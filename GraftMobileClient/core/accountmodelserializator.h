#ifndef ACCOUNTMODELSERIALIZATOR_H
#define ACCOUNTMODELSERIALIZATOR_H

#include <QByteArray>

class AccountModel;

class AccountModelSerializator
{
public:
    static QByteArray serialize(AccountModel *model);
    static void deserialize(const QByteArray &array, AccountModel *model);
};

#endif // ACCOUNTMODELSERIALIZATOR_H
