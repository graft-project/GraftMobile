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
    bool isSelected() const;
    QString currency() const;

    void setImagePath(const QString &imagePath);
    void setName(const QString &name);
    void setCost(double cost);
    void setSelected(bool selected);
    void setCurrency(const QString &currency);

    void changeSelection();

private:
    QString mImagePath;
    QString mName;
    double mCost;
    bool mSelected;
    QString mCurrency;
};

#endif // PRODUCTITEM_H
