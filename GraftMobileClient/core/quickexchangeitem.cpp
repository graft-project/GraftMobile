#include "quickexchangeitem.h"

QuickExchangeItem::QuickExchangeItem(const QString &name, const QString &code,
                                     const QString &price, bool primary)
    : mName(name), mCode(code), mPrice(price), mPrimary(primary)
{
}

QString QuickExchangeItem::name() const
{
    return mName;
}

void QuickExchangeItem::setName(const QString &name)
{
    mName = name;
}

QString QuickExchangeItem::code() const
{
    return mCode;
}

void QuickExchangeItem::setCode(const QString &code)
{
    mCode = code;
}

QString QuickExchangeItem::price() const
{
    return mPrice;
}

void QuickExchangeItem::setPrice(const QString &price)
{
    mPrice = price;
}

bool QuickExchangeItem::primary() const
{
    return mPrimary;
}

void QuickExchangeItem::setPrimary(bool primary)
{
    mPrimary = primary;
}
