#include "productmodel.h"
#include <QDebug>

ProductModel::ProductModel(QObject *parent) : QAbstractListModel(parent)
{}

ProductModel::~ProductModel()
{
    qDeleteAll(mProducts);
}

QVariant ProductModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= mProducts.count())
    {
        return QVariant();
    }

    ProductItem *productItem = mProducts[index.row()];

    switch (role) {
    case TitleRole:
        return productItem->name();
    case CostRole:
        return productItem->cost();
    case ImageRole:
        return productItem->imagePath();
    case CurrencyRole:
        if(productItem->currency() == QLatin1String("USD"))
        {
            return "$";
        }
        else if (productItem->currency() == QLatin1String("GRAFT"))
        {
            return "g";
        }
        else
        {
            return "$";
        }
    default:
        return QVariant();
    }
}

int ProductModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return mProducts.count();
}

QVector<ProductItem *> ProductModel::products() const
{
    return mProducts;
}

void ProductModel::dump()
{
    for(ProductItem* b : mProducts)
    {
        qDebug() << b->name();
    }
}

void ProductModel::add(const QString &imagePath, const QString &name, double cost,
                       const QString &currency)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    mProducts << (new ProductItem(imagePath, name, cost, currency));
    endInsertRows();
}

QHash<int, QByteArray> ProductModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TitleRole] = "name";
    roles[CostRole] = "cost";
    roles[ImageRole] = "imagePath";
    roles[CurrencyRole] = "currency";
    return roles;
}

