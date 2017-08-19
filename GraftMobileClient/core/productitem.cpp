#include "productitem.h"

ProductItem::ProductItem()
{}

ProductItem::ProductItem(const QString &imagePath, const QString &name, double cost, bool elected,
                         const QString &currency)
    : mImagePath(imagePath),
      mName(name),
      mCost(cost),
      mElected(elected),
      mCurrency(currency)
{}

void ProductItem::setImagePath(const QString &imagePath)
{
    mImagePath = imagePath;
}

void ProductItem::setName(const QString &name)
{
    mName = name;
}

void ProductItem::setCost(double cost)
{
    mCost = cost;
}

void ProductItem::setElected(bool elected)
{
    mElected = elected;
}

void ProductItem::setCurrency(const QString &currency)
{
    mCurrency = currency;
}

QString ProductItem::imagePath() const
{
    return mImagePath;
}

QString ProductItem::name() const
{
    return mName;
}

double ProductItem::cost() const
{
    return mCost;
}

bool ProductItem::elected() const
{
    return mElected;
}

QString ProductItem::currency() const
{
    return mCurrency;
}
