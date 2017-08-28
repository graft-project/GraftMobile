#include "carditem.h"

CardItem::CardItem()
{
}

CardItem::CardItem(const QString &number, const unsigned &cv2Code,
                   const unsigned &expirationMonth, const unsigned &expirationYear)
    : mName("Graft"), mNumber(number),mCV2Code(cv2Code),
      mExpirationMonth(expirationMonth), mExpirationYear(expirationYear)
{
}

QString CardItem::getNumber() const
{
    return mNumber;
}

void CardItem::setNumber(const QString &value)
{
    mNumber = value;
}

unsigned CardItem::getCV2Code() const
{
    return mCV2Code;
}

void CardItem::setCV2Code(const unsigned &value)
{
    mCV2Code = value;
}

unsigned CardItem::getExpirationMonth() const
{
    return mExpirationMonth;
}

void CardItem::setExpirationMonth(const unsigned &value)
{
    mExpirationMonth = value;
}

unsigned CardItem::getExpirationYear() const
{
    return mExpirationYear;
}

void CardItem::setExpirationYear(const unsigned &value)
{
    mExpirationYear = value;
}

QString CardItem::getName() const
{
    return mName;
}

void CardItem::setName(const QString &value)
{
    mName = value;
}
