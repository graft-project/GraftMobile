#include "selectedproductproxymodel.h"
#include "productmodel.h"

SelectedProductProxyModel::SelectedProductProxyModel(QObject *parent)
    : QSortFilterProxyModel(parent)
{
}

bool SelectedProductProxyModel::filterAcceptsRow(int source_row,
                                                 const QModelIndex &source_parent) const
{
    if (sourceModel())
    {
        QModelIndex index = sourceModel()->index(source_row, 0, source_parent);
        if (index.isValid())
        {
            QVariant valueRole = index.data(ProductModel::SelectedRole);
            if (valueRole.isValid())
            {
                return valueRole.toBool();
            }
        }
    }
    return false;
}

QHash<int, QByteArray> SelectedProductProxyModel::roleNames() const
{
    if(sourceModel())
    {
        return sourceModel()->roleNames();
    }

    return QSortFilterProxyModel::roleNames();
}
