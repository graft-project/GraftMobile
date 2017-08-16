#include "productitem.h"

ProductItem::ProductItem()
{}

ProductItem::ProductItem(const QString &image, const QString &name, double cost)
    : mImage(image),
      mName(name),
      mCost(cost)
{}

QString ProductItem::image() const
{
    return mImage;
}

QString ProductItem::name() const
{
    return mName;
}

double ProductItem::cost() const
{
    return mCost;
}
