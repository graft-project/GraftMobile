#ifndef PRODUCTITEM_H
#define PRODUCTITEM_H

#include <QString>

class ProductItem
{
public:
    ProductItem();
    ProductItem(const QString &imagePath, const QString &name, double cost, bool elected,
                const QString &currency);
    QString imagePath() const;
    QString name() const;
    double cost() const;
    bool elected() const;
    QString currency() const;

    void setImagePath(const QString &imagePath);
    void setName(const QString &name);
    void setCost(double cost);
    void setElected(bool elected);
    void setCurrency(const QString &currency);

private:
    QString mImagePath;
    QString mName;
    double mCost;
    bool mElected;
    QString mCurrency;
};

#endif // PRODUCTITEM_H
