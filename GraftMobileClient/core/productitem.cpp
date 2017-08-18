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

