#include "selectedproductproxymodel.h"

SelectedProductProxyModel::SelectedProductProxyModel(QObject *parent) : QSortFilterProxyModel(parent)
{
}

bool SelectedProductProxyModel::filterAcceptsRow(int source_row, const QModelIndex &source_parent) const
{
    return true;
}
