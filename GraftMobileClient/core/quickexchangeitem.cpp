#include "quickexchangeitem.h"

QuickExchangeItem::QuickExchangeItem(QString iconPath, QString name,
                                     QString price, QString code, bool isBold)
    : mIconPath(iconPath), mName(name), mPrice(price), mCode(code), mIsBold(isBold)
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

bool QuickExchangeItem::isBold() const
{
    return mIsBold;
}

void QuickExchangeItem::setIsBold(bool isBold)
{
    mIsBold = isBold;
}
