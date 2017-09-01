#include "carditem.h"

static const QString scHideCardNumber("XXXX");

CardItem::CardItem()
{
}

CardItem::CardItem(const QString &name, const QString &number, unsigned cv2Code,
                   unsigned expirationMonth, unsigned expirationYear)
    : mName(name)
    ,mNumber(number)
    ,mCV2Code(cv2Code)
    ,mExpirationMonth(expirationMonth)
    ,mExpirationYear(expirationYear)
{
}

QString CardItem::number() const
{
    return mNumber;
}

void CardItem::setNumber(const QString &value)
{
    mNumber = value;
}

QString CardItem::hideNumber() const
{
    QString currentCardHideNumber(scHideCardNumber);
    currentCardHideNumber.append(number().right(4));
    return currentCardHideNumber;
}

unsigned CardItem::cv2Code() const
{
    return mCV2Code;
}

void CardItem::setCV2Code(unsigned value)
{
    mCV2Code = value;
}

unsigned CardItem::expirationMonth() const
{
    return mExpirationMonth;
}

void CardItem::setExpirationMonth(unsigned value)
{
    mExpirationMonth = value;
}

unsigned CardItem::expirationYear() const
{
    return mExpirationYear;
}

void CardItem::setExpirationYear(unsigned value)
{
    mExpirationYear = value;
}

QString CardItem::name() const
{
    return mName;
}

void CardItem::setName(const QString &value)
{
    mName = value;
}
