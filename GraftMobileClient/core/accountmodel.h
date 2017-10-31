#ifndef ACCOUNTMODEL_H
#define ACCOUNTMODEL_H

#include <QAbstractListModel>

class AccountItem;

class AccountModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum AccountRoles {
        TitleRole = Qt::UserRole + 1,
        CurrencyRole,
        NumberRole
    };
    explicit AccountModel(QObject *parent = nullptr);
    ~AccountModel();

    QVector<AccountItem *> accounts() const;
    QVariant data(const QModelIndex &index, int role) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    int rowCount(const QModelIndex &parent = QModelIndex()) const;

public slots:
    void add(const QString &name, const QString &currency, unsigned &number);

protected:
    QHash<int, QByteArray> roleNames() const;

private:
    QVector<AccountItem *> mAccounts;
};
#endif // ACCOUNTMODEL_H
