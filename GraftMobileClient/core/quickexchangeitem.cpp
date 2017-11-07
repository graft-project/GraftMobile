#include "quickexchangeitem.h"

QuickExchangeItem::QuickExchangeItem(const QString &iconPath, const QString &name,
                                     const QString &price, const QString &code, bool primary)
    : mIconPath(iconPath), mName(name), mPrice(price), mCode(code), mPrimary(primary)
{
}

QString QuickExchangeItem::iconPath() const
{
    return mIconPath;
}

void QuickExchangeItem::setIconPath(const QString &iconPath)
{
    mIconPath = iconPath;
}

QString QuickExchangeItem::name() const
{
    return mName;
}

void QuickExchangeItem::setName(const QString &name)
{
    mName = name;
}

QString QuickExchangeItem::price() const
{
    return mPrice;
}

void QuickExchangeItem::setPrice(const QString &price)
{
    mPrice = price;
}

QString QuickExchangeItem::code() const
{
    return mCode;
}

void QuickExchangeItem::setCode(const QString &code)
{
    mCode = code;
}

bool QuickExchangeItem::primary() const
{
    return mPrimary;
}

void QuickExchangeItem::setPrimary(bool primary)
{
    mPrimary = primary;
}
