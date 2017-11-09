#include "carditem.h"

static const QString scHideCardNumber("XXXX");

CardItem::CardItem(const QString &name, const QString &number, unsigned cv2Code,
                   const QString &expirationDate)
    : mName(name)
    ,mNumber(number)
    ,mCV2Code(cv2Code)
    ,mExpirationDate(expirationDate)
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

QString CardItem::expirationDate() const
{
    return mExpirationDate;
}

void CardItem::setExpirationDate(const QString &value)
{
    mExpirationDate = value;
}

QString CardItem::name() const
{
    return mName;
}

void CardItem::setName(const QString &value)
{
    mName = value;
}
