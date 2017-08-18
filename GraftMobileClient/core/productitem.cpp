#include "productitem.h"

ProductItem::ProductItem()
{}

ProductItem::ProductItem(const QString &imagePath, const QString &name, double cost, bool stance,
                         const QString &currency)
    : mImagePath(imagePath),
      mName(name),
      mCost(cost),
      mStance(stance),
      mCurrency(currency)
{}

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

bool ProductItem::stance() const
{
    return mStance;
}

QString ProductItem::currency() const
{
    return mCurrency;
}

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

void ProductItem::setStance(bool stance)
{
    mStance = stance;
}

void ProductItem::setCurrency(const QString &currency)
{
    mCurrency = currency;
}

