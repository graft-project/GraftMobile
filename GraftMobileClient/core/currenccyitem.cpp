#include "currenccyitem.h"

CurrencyItem::CurrencyItem(const QString &name, const int &code)
    : mName(name), mCode(code)
{}

QString CurrencyItem::name() const
{
    return mName;
}

int CurrencyItem::code() const
{
    return mCode;
}
