#include "productitem.h"
#include "defines.h"

#include <QUrl>
#include <QFile>
#include <QFileInfo>

ProductItem::ProductItem()
{}

ProductItem::ProductItem(const QString &imagePath, const QString &name, double cost,
                         const QString &currency, const QString &description)
    : mImagePath(imagePath),
      mName(name),
      mCost(cost),
      mSelected(false),
      mCurrency(currency),
      mDescription(description)
{
    setImagePath(imagePath);
}

QString ProductItem::imagePath() const
{
    QString imageDataLocation = callImageDataPath();
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
    QString imageDataLocation = callImageDataPath();
    QFileInfo newImagePath(imagePath);
    if (mImagePath != newImagePath.fileName())
    {
        if (!mImagePath.isEmpty())
        {
            QFile::remove(imageDataLocation + mImagePath);
        }
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
