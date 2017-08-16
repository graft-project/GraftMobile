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
    explicit ProductModel(QObject *parent = 0);
    QVariant data(const QModelIndex &index, int role) const;
    int rowCount(const QModelIndex &parent = QModelIndex()) const;

protected:
    QHash<int, QByteArray> roleNames() const;

public slots:
    void add(const QString &name, double cost, const QString &currency = QString());

private:
    QVector<ProductItem> mProducts;
};
#endif // PRODUCTMODEL_H
