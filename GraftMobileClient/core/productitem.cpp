#include "productitem.h"
#include "define.h"

#include <QFileInfo>
#include <QFile>
#include <QUrl>

ProductItem::ProductItem()
{}

ProductItem::ProductItem(const QString &imagePath, const QString &name, double cost,
                         const QString &currency, const QString &description)
    : mName(name),
      mCost(cost),
      mSelected(false),
      mCurrency(currency),
      mDescription(description)
{
    setImagePath(imagePath);
}

QString ProductItem::imagePath() const
{
    if (!mImagePath.isEmpty())
    {
        return QUrl::fromLocalFile(imageDataLocation + mImagePath).toString();
    }
    return QString();
}

QString ProductItem::name() const
{
    return mName;
}

double ProductItem::cost() const
{
    return mCost;
}

bool ProductItem::isSelected() const
{
    return mSelected;
}

QString ProductItem::currency() const
{
    return mCurrency;
}

QString ProductItem::description() const
{
    return mDescription;
}

void ProductItem::setImagePath(const QString &imagePath)
{
    if (mImagePath != imagePath)
    {
        QFile::remove(imageDataLocation + mImagePath);
        QFileInfo newImagePath(imagePath);
        mImagePath = newImagePath.fileName();
    }
}

void ProductItem::setName(const QString &name)
{
    mName = name;
}

void ProductItem::setCost(double cost)
{
    mCost = cost;
}

void ProductItem::setSelected(bool selected)
{
    mSelected = selected;
}

void ProductItem::setCurrency(const QString &currency)
{
    mCurrency = currency;
}

void ProductItem::setDescription(const QString &description)
{
    mDescription = description;
}

void ProductItem::changeSelection()
{
    mSelected = !mSelected;
}
