#ifndef PRODUCTMODEL_H
#define PRODUCTMODEL_H

#include <QAbstractListModel>

class ProductItem;

class ProductModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum ProductRoles {
        TitleRole = Qt::UserRole + 1,
        CostRole,
        ImageRole,
        SelectedRole,
        CurrencyRole
    };

    explicit ProductModel(QObject *parent = 0);
    ~ProductModel();

    QVariant data(const QModelIndex &index, int role) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVector<ProductItem *> products() const;
    Q_INVOKABLE void changeSelection(int index);
    Q_INVOKABLE double totalCost() const;
    Q_INVOKABLE unsigned int selectedProductCount() const;
    void clear();

signals:
    void selectedProductCountChanged(unsigned int count);

public slots:
    void add(const QString &imagePath, const QString &name, double cost,
             const QString &currency = QString());

protected:
    QHash<int, QByteArray> roleNames() const;

private:
    QVector<ProductItem*> mProducts;
};
#endif // PRODUCTMODEL_H
