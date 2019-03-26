#ifndef SELECTEDPRODUCTPROXYMODEL_H
#define SELECTEDPRODUCTPROXYMODEL_H

#include <QSortFilterProxyModel>

class SelectedProductProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
public:
    SelectedProductProxyModel(QObject *parent = nullptr);

    bool filterAcceptsRow(int source_row, const QModelIndex &source_parent) const override;

protected:
    QHash<int, QByteArray> roleNames() const override;
};

#endif // SELECTEDPRODUCTPROXYMODEL_H
