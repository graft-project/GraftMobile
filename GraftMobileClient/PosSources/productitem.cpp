#include "productitem.h"

ProductItem::ProductItem(const QString &image, const QString &name, double cost)
    : m_image(image),
      m_name(name),
      m_cost(cost)
{}

QString ProductItem::image() const
{
    return m_image;
}

QString ProductItem::name() const
{
    return m_name;
}

double ProductItem::cost() const
{
    return m_cost;
}
