#include "accountmodel.h"
#include "accountitem.h"

AccountModel::AccountModel(QObject *parent) : QAbstractListModel(parent)
{}

AccountModel::~AccountModel()
{
    qDeleteAll(mAccounts);
}

QVector<AccountItem *> AccountModel::cards() const
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

    switch (role) {
    case TitleRole:
        return accountItem->name();
    case CurrencyRole:
        return accountItem->currency();
    case NumberRole:
        return accountItem->number();
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
        case TitleRole:
            mAccounts[index.row()]->setName(value.toString());
            break;
        case CurrencyRole:
            mAccounts[index.row()]->setCV2Code(value.toString());
            break;
        case NumberRole:
            mAccounts[index.row()]->setNumber(value.toUInt());
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

void AccountModel::add(const QString &name, const QString &currency, unsigned &number)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    mAccounts << (new AccountItem(name, currency, number));
    endInsertRows();
}

QHash<int, QByteArray> AccountModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TitleRole] = "accountName";
    roles[CurrencyRole] = "type";
    roles[NumberRole] = "accountNumber";
    return roles;
}
