#ifndef CURRENCYMODEL_H
#define CURRENCYMODEL_H

#include <QAbstractListModel>

class CurrencyItem;

class CurrencyModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum CurrencyRoles {
        TitleRole = Qt::UserRole + 1,
        CodeRole
    };
    Q_ENUM(CurrencyRoles)

    explicit CurrencyModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    Q_INVOKABLE bool setCurrencyData(int index, const QVariant &value, int role);

public slots:
    void add(const QString &name, int &code);

protected:
    QHash<int, QByteArray> roleNames() const;

private:
    QVector<CurrencyItem*> mCurrency;
};

#endif // CURRENCYMODEL_H
