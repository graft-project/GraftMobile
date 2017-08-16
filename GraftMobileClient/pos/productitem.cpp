#include "productitem.h"

ProductItem::ProductItem()
{}

ProductItem::ProductItem(const QString &imagePath, const QString &name, double cost,
                         const QString &currency)
    : mImagePath(imagePath),
      mName(name),
      mCost(cost),
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

QString ProductItem::currency() const
{
    return mCurrency;
}
