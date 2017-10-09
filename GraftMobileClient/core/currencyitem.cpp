#include "currencyitem.h"

CurrencyItem::CurrencyItem(const QString &name, const QString &code)
    : mName(name), mCode(code)
{}

QString CurrencyItem::name() const
{
    return mName;
}

QString CurrencyItem::code() const
{
    return mCode;
}

void CurrencyItem::setName(const QString &name)
{
    mName = name;
}

void CurrencyItem::setCode(const QString &code)
{
    mCode = code;
}
