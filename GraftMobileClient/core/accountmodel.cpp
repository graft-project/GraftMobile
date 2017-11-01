#include "accountmodel.h"
#include "accountitem.h"

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

    switch (role) {
    case ImagePathRole:
        return accountItem->imagePath();
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

bool AccountModel::existWalletNumbers(const QString &number)
{
    QList<QString> walletNumbers;
    for(int i = 0; i < mAccounts.size(); ++i)
    {
        walletNumbers.append(mAccounts.at(i)->number());
    }

    if(!walletNumbers.contains(number))
    {
        return true;
    }
    return false;
}

void AccountModel::add(const QString &imagePath, const QString &name, const QString &currency,
                       const QString &number)
{
    if (existWalletNumbers(number))
    {
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        mAccounts << (new AccountItem(imagePath, name, currency, number));
        endInsertRows();
    }
}

QHash<int, QByteArray> AccountModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[ImagePathRole] = "imagePath";
    roles[TitleRole] = "accountName";
    roles[CurrencyRole] = "type";
    roles[NumberRole] = "accountNumber";
    return roles;
}
