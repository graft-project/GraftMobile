#ifndef ACCOUNTMODELSERIALIZATOR_H
#define ACCOUNTMODELSERIALIZATOR_H

#include <QByteArray>

class AccountModel;
class CurrencyModel;

class AccountModelSerializator
{
public:
    static QByteArray serialize(AccountModel *model, CurrencyModel *mCurrencyModel);
    static void deserialize(const QByteArray &array, AccountModel *model);
};

#endif // ACCOUNTMODELSERIALIZATOR_H
