#include "accountitem.h"

AccountItem::AccountItem()
{}

AccountItem::AccountItem(const QString &name, const QString &currency, unsigned &number)
    : mName(name),
      mCurrency(currency),
      mNumber(number)
{}

QString AccountItem::name() const
{
    return mName;
}

QString AccountItem::currency() const
{
    return mCurrency;
}

unsigned AccountItem::number() const
{
    return mNumber;
}

void AccountItem::setName(const QString &name)
{
    mName = name;
}

void AccountItem::setCurrency(const QString &currency)
{
    mCurrency = currency;
}

void AccountItem::setNumber(const unsigned &number)
{
    mNumber = number;
}
