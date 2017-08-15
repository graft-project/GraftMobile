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
    QString mimage;
    QString mname;
    double mcost;
};

#endif // PRODUCTITEM_H
