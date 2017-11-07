#include "quickexchangemodel.h"
#include "quickexchangeitem.h"

QuickExchangeModel::QuickExchangeModel(QObject *parent) : QAbstractListModel(parent)
{
}

QuickExchangeModel::~QuickExchangeModel()
{
    qDeleteAll(mQuickExchangeItems);
}

QVariant QuickExchangeModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= mQuickExchangeItems.count())
    {
        return QVariant();
    }
    QuickExchangeItem *quickExchangeItem = mQuickExchangeItems[index.row()];
    switch (role)
    {
    case IconPathRole:
        return quickExchangeItem->iconPath();
    case NameRole:
        return quickExchangeItem->name();
    case PriceRole:
        if (quickExchangeItem->price().toDouble() < 0.0001)
        {
            return QStringLiteral("N/A");
        }
        else
        {
            return quickExchangeItem->price().number(quickExchangeItem->price().toDouble(), 'f', 4);
        }
    case CodeRole:
        return quickExchangeItem->code();
    case PrimaryRole:
        return quickExchangeItem->primary();
    default:
        return QVariant();
    }
}

bool QuickExchangeModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (index.isValid() && value.isValid() && data(index, role) != value)
    {
        switch (role)
        {
        case IconPathRole:
            mQuickExchangeItems[index.row()]->setIconPath(value.toString());
            break;
        case NameRole:
            mQuickExchangeItems[index.row()]->setName(value.toString());
            break;
        case PriceRole:
            mQuickExchangeItems[index.row()]->setPrice(value.toString());
            break;
        case CodeRole:
            mQuickExchangeItems[index.row()]->setCode(value.toString());
            break;
        case PrimaryRole:
            mQuickExchangeItems[index.row()]->setPrimary(value.toBool());
            break;
        default:
            break;
        }
        emit dataChanged(index, index, QVector<int>() << role);
        return true;
    }
    return false;
}

int QuickExchangeModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return mQuickExchangeItems.count();
}

void QuickExchangeModel::add(const QString &iconPath, const QString &name, const QString &price,
                             const QString &code, bool primary)
{
    if (!iconPath.isEmpty() || !name.isEmpty() || !price.isEmpty() || !code.isEmpty())
    {
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        mQuickExchangeItems << new QuickExchangeItem(iconPath, name, price, code, primary);
        endInsertRows();
    }
}

void QuickExchangeModel::clear()
{
    beginRemoveRows(QModelIndex(), 0, mQuickExchangeItems.count());
    qDeleteAll(mQuickExchangeItems);
    mQuickExchangeItems.clear();
    endRemoveRows();
}

QHash<int, QByteArray> QuickExchangeModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IconPathRole] = "iconPath";
    roles[NameRole] = "name";
    roles[PriceRole] = "price";
    roles[CodeRole] = "code";
    roles[PrimaryRole] = "primary";
    return roles;
}
