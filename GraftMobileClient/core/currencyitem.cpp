#include "currencyitem.h"

CurrencyItem::CurrencyItem(const QString &name, const QString &code, const QString &image)
    : mName(name), mCode(code), mImage(image)
{}

QString CurrencyItem::name() const
{
    return mName;
}

QString CurrencyItem::code() const
{
    return mCode;
}

QString CurrencyItem::image() const
{
    return mImage;
}

void CurrencyItem::setName(const QString &name)
{
    mName = name;
}

void CurrencyItem::setCode(const QString &code)
{
    mCode = code;
}

void CurrencyItem::setImage(const QString &image)
{
    mImage = image;
}
