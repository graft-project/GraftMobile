#include "accountmodel.h"
#include "accountitem.h"
#include <algorithm>

AccountModel::AccountModel(QObject *parent) : QAbstractListModel(parent)
{}

AccountModel::~AccountModel()
{
    qDeleteAll(mAccounts);
}

QVector<AccountItem *> AccountModel::accounts() const
{
    return mAccounts;
}

QVariant AccountModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= mAccounts.count())
    {
        return QVariant();
    }

    AccountItem *accountItem = mAccounts[index.row()];
    Q_ASSERT(accountItem);
    switch (role) {
    case ImagePathRole:
        return accountItem->imagePath();
    case TitleRole:
        return accountItem->name();
    case CurrencyRole:
        return accountItem->currency();
    case NumberRole:
        return accountItem->number();
    case BalanceRole:
        return accountItem->balance();
    default:
        return QVariant();
    }

}

bool AccountModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (index.isValid() && value.isValid() && data(index, role) != value)
    {
        switch (role)
        {
        case ImagePathRole:
            mAccounts[index.row()]->setImagePath(value.toString());
            break;
        case TitleRole:
            mAccounts[index.row()]->setName(value.toString());
            break;
        case CurrencyRole:
            mAccounts[index.row()]->setCurrency(value.toString());
            break;
        case NumberRole:
            mAccounts[index.row()]->setNumber(value.toString());
            break;
        case BalanceRole:
            mAccounts[index.row()]->setBalance(value.toDouble());
            break;
        default:
            break;
        }
        emit dataChanged(index, index, QVector<int>() << role);
        return true;
    }
    return false;
}

int AccountModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return mAccounts.count();
}

bool AccountModel::isWalletNumberExists(const QString &number) const
{
    std::any_of(mAccounts.cbegin(), mAccounts.cend(), [&number](AccountItem *account){
        Q_ASSERT(account);
        return account->number() == number;
    });
}

bool AccountModel::add(const QString &imagePath, const QString &name, const QString &currency,
                       const QString &number)
{
    if (!isWalletNumberExists(number))
    {
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        mAccounts << (new AccountItem(imagePath, name, currency, number));
        endInsertRows();
        return true;
    }
    return false;
}

QHash<int, QByteArray> AccountModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[ImagePathRole] = "imagePath";
    roles[TitleRole] = "accountName";
    roles[CurrencyRole] = "type";
    roles[NumberRole] = "accountNumber";
    roles[BalanceRole] = "balance";
    return roles;
}
