#ifndef PRODUCTITEM_H
#define PRODUCTITEM_H

#include <QString>

class ProductItem
{
public:
    ProductItem();
    ProductItem(const QString &image, const QString &name, double cost);
    QString image() const;
    QString name() const;
    double cost() const;

private:
    QString mImage;
    QString mName;
    double mCost;
};

#endif // PRODUCTITEM_H
