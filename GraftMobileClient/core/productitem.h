#ifndef PRODUCTITEM_H
#define PRODUCTITEM_H

#include <QString>

class ProductItem
{
public:
    ProductItem(const QString &imagePath, const QString &name, double cost,
                const QString &currency, const QString &description);
    QString imagePath() const;
    QString name() const;
    double cost() const;
    bool isSelected() const;
    QString currency() const;
    QString description() const;

    void setImagePath(const QString &imagePath);
    void setName(const QString &name);
    void setCost(double cost);
    void setSelected(bool selected);
    void setCurrency(const QString &currency);
    void setDescription(const QString &description);

    void changeSelection();
    void removeImage();

private:
    QString mImagePath;
    QString mName;
    double mCost;
    bool mSelected;
    QString mCurrency;
    QString mDescription;
};

#endif // PRODUCTITEM_H
