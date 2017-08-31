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

QString CardItem::getHideNumber() const
{
    QString hideCardNumber = mNumber;
    QString hideNumber;
    for(int i = 0; i < hideCardNumber.size() - 5; ++i)
    {
        hideNumber.append(QChar('X'));
    }
    hideCardNumber.replace(0, hideCardNumber.size() - 5, hideNumber);
    return hideCardNumber;
}

unsigned CardItem::getCV2Code() const
{
    return mCV2Code;
}

void CardItem::setCV2Code(unsigned value)
{
    mCV2Code = value;
}

unsigned CardItem::getExpirationMonth() const
{
    return mExpirationMonth;
}

void CardItem::setExpirationMonth(unsigned value)
{
    mExpirationMonth = value;
}

unsigned CardItem::getExpirationYear() const
{
    return mExpirationYear;
}

void CardItem::setExpirationYear(unsigned value)
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
