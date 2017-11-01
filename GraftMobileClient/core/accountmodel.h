#ifndef ACCOUNTMODEL_H
#define ACCOUNTMODEL_H

#include <QAbstractListModel>

class AccountItem;

class AccountModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum AccountRoles {
        ImagePathRole = Qt::UserRole + 1,
        TitleRole ,
        CurrencyRole,
        NumberRole
    };
    explicit AccountModel(QObject *parent = nullptr);
    ~AccountModel();

    QVector<AccountItem *> accounts() const;
    QVariant data(const QModelIndex &index, int role) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    int rowCount(const QModelIndex &parent = QModelIndex()) const;

    Q_INVOKABLE bool existWalletNumbers(const QString &number);

public slots:
    void add(const QString &imagePath, const QString &name, const QString &currency, const QString &number);

protected:
    QHash<int, QByteArray> roleNames() const;

private:
    QVector<AccountItem *> mAccounts;
};
#endif // ACCOUNTMODEL_H
