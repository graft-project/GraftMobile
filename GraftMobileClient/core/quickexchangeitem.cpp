#include "quickexchangeitem.h"

QuickExchangeItem::QuickExchangeItem(const QString &iconPath, const QString &name,
                                     const QString &code, const QString &price, bool primary)
    : mIconPath(iconPath), mName(name), mCode(code), mPrice(price), mPrimary(primary)
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
