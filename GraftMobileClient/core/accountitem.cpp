#include "accountitem.h"

AccountItem::AccountItem()
{}

AccountItem::AccountItem(const QString &imagePath, const QString &name, const QString &currency,
                         const QString &number)
    : mImagePath(imagePath),
      mName(name),
      mCurrency(currency),
      mNumber(number),
      mBalance()
{}

QString AccountItem::imagePath() const
{
    return mImagePath;
}

QString AccountItem::name() const
{
    return mName;
}

QString AccountItem::currency() const
{
    return mCurrency;
}

QString AccountItem::number() const
{
    return mNumber;
}

double AccountItem::balance() const
{
    return mBalance;
}

void AccountItem::setImagePath(const QString &imagePath)
{
    mImagePath = imagePath;
}

void AccountItem::setName(const QString &name)
{
    mName = name;
}

void AccountItem::setCurrency(const QString &currency)
{
    mCurrency = currency;
}

void AccountItem::setNumber(const QString &number)
{
    mNumber = number;
}

void AccountItem::setBalance(double balance)
{
    mBalance = balance;
}
