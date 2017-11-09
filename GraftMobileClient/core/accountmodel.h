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
        NumberRole,
        BalanceRole
    };
    Q_ENUM(AccountRoles)

    explicit AccountModel(QObject *parent = nullptr);
    ~AccountModel();

    QVector<AccountItem *> accounts() const;
    QVariant data(const QModelIndex &index, int role) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    Q_INVOKABLE bool isWalletNumberExists(const QString &number) const;

public slots:
    bool add(const QString &imagePath, const QString &name, const QString &currency,
             const QString &number);

protected:
    QHash<int, QByteArray> roleNames() const override;

private:
    QVector<AccountItem *> mAccounts;
};
#endif // ACCOUNTMODEL_H
