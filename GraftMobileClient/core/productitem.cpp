#include "productitem.h"
#include "devicedetector.h"
#include "keygenerator.h"
#include "defines.h"

#include <QUrl>
#include <QDir>
#include <QFile>
#include <QFileInfo>

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
        QDir lDir(imageDataLocation);
        return QUrl::fromLocalFile(lDir.filePath(mImagePath)).toString();
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
            QDir lDir(imageDataLocation);
            QFile::remove(lDir.filePath(mImagePath));
        }
        QString lCopiedImage(imageDataLocation + newImagePath.fileName());
        if (DeviceDetector::isDesktop())
        {
            if (!QFileInfo::exists(lCopiedImage))
            {
                lCopiedImage.insert(lCopiedImage.lastIndexOf("."), KeyGenerator::generateUUID(4));
            }
            QFile::copy(QUrl(imagePath).toLocalFile(), lCopiedImage);
        }
        mImagePath = QFile(lCopiedImage).fileName();
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

void ProductItem::removeImage()
{
    if (!mImagePath.isEmpty())
    {
        QFile lImage(mImagePath);
        lImage.remove();
    }
}
