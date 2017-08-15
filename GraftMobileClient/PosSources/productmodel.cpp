#include "productmodel.h"

ProductModel::ProductModel(QObject *parent) : QAbstractListModel(parent)
{}

int ProductModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_products.count();
}

QVariant ProductModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_products.count())
        return QVariant();

    const ProductItem &productItem = m_products[index.row()];
    if (role == TitleRole)
        return productItem.name();
    else if (role == CostRole)
        return productItem.cost();
    else if (role == ImageRole)
        return productItem.image();
    return QVariant();
}

QHash<int, QByteArray> ProductModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TitleRole] = "name";
    roles[CostRole] = "cost";
    roles[ImageRole] = "image";
    return roles;
}

void ProductModel::add(const QString &name, double cost, const QString &currency)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_products << ProductItem("qrc:/examples/bob-haircuts.png", name, cost);
    endInsertRows();
}
