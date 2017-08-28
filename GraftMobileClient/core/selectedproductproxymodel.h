#ifndef SELECTEDPRODUCTPROXYMODEL_H
#define SELECTEDPRODUCTPROXYMODEL_H

#include <QSortFilterProxyModel>
#include <QObject>

class SelectedProductProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT

public:
    SelectedProductProxyModel(QObject *parent = 0);

    bool filterAcceptsRow(int source_row, const QModelIndex &source_parent) const override;
};

#endif // SELECTEDPRODUCTPROXYMODEL_H
