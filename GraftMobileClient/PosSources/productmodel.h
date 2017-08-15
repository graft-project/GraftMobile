#ifndef PRODUCTMODEL_H
#define PRODUCTMODEL_H

#include <QAbstractListModel>
#include "productitem.h"

class ProductModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum ProductRoles {
        TitleRole = Qt::UserRole + 1,
        CostRole,
        ImageRole
    };
    ProductModel(QObject *parent = 0);
    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;

public slots:
    void add(const QString &name, double cost, const QString &currency = QString());

private:
    QList<ProductItem> m_products;
};
#endif // PRODUCTMODEL_H
