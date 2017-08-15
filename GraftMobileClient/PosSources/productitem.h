#ifndef PRODUCTITEM_H
#define PRODUCTITEM_H

#include <QString>

class ProductItem
{
public:
    ProductItem(const QString &image, const QString &name, double cost);
    QString image() const;
    QString name() const;
    double cost() const;

private:
    QString m_image;
    QString m_name;
    double m_cost;
};

#endif // PRODUCTITEM_H
