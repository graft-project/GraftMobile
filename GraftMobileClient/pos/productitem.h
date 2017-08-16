#ifndef PRODUCTITEM_H
#define PRODUCTITEM_H

#include <QString>

class ProductItem
{
public:
    ProductItem();
    ProductItem(const QString &imagePath, const QString &name, double cost,
                const QString &currency);
    QString imagePath() const;
    QString name() const;
    double cost() const;
    QString currency() const;

private:
    QString mImagePath;
    QString mName;
    double mCost;
    QString mCurrency;
};

#endif // PRODUCTITEM_H
