#include "productitem.h"

ProductItem::ProductItem(const QString &image, const QString &name, double cost)
    : mimage(image),
      mname(name),
      mcost(cost)
{}

QString ProductItem::image() const
{
    return mimage;
}

QString ProductItem::name() const
{
    return mname;
}

double ProductItem::cost() const
{
    return mcost;
}
