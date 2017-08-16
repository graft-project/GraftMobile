#include "productmodel.h"

ProductModel::ProductModel(QObject *parent) : QAbstractListModel(parent)
{}

int ProductModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return mProducts.count();
}

QVariant ProductModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= mProducts.count())
    {
        return QVariant();
    }

    const ProductItem &productItem = mProducts[index.row()];

    switch (role) {
    case TitleRole:
        return productItem.name();
    case CostRole:
        return productItem.cost();
    case ImageRole:
        return productItem.imagePath();
    case CurrencyRole:
        if(productItem.currency() == QLatin1String("USD"))
        {
            return "$";
        }
        else if (productItem.currency() == QLatin1String("GRAFT"))
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

QHash<int, QByteArray> ProductModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TitleRole] = "name";
    roles[CostRole] = "cost";
    roles[ImageRole] = "imagePath";
    roles[CurrencyRole] = "currency";
    return roles;
}

void ProductModel::add(const QString &imagePath, const QString &name, double cost,
                       const QString &currency)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    mProducts << (ProductItem(imagePath, name, cost, currency));
    endInsertRows();
}
