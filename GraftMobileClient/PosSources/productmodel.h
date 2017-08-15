#ifndef PRODUCTMODEL_H
#define PRODUCTMODEL_H

#include <QAbstractListModel>
#include "productitem.h"

class ProductModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit ProductModel(QObject *parent = 0);
    enum ProductRoles {
        TitleRole = Qt::UserRole + 1,
        CostRole,
        ImageRole
    };
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;

protected:
    int rowCount(const QModelIndex &parent = QModelIndex()) const;

public slots:
    void add(const QString &name, double cost, const QString &currency = QString());

private:
    QList<ProductItem> mproducts;
};
#endif // PRODUCTMODEL_H
