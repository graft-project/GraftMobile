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
    if (!index.isValid() || index.row() < 0 || index.row() >= mQuickExchangeItems.count())
    {
        return QVariant();
    }

    QuickExchangeItem *quickExchangeItem = mQuickExchangeItems[index.row()];
    Q_ASSERT(quickExchangeItem);

    switch (role)
    {
    case IconPathRole:
        return imagePath(quickExchangeItem->code());
    case NameRole:
        return quickExchangeItem->name();
    case CodeRole:
        return quickExchangeItem->code();
    case PriceRole:
    {
        double price = quickExchangeItem->price().toDouble();
        if (price < 0.0001)
        {
            return QStringLiteral("N/A");
        }
        else
        {
            return QString::number(price, 'f', 4);
        }
    }
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
            break;
        case NameRole:
            mQuickExchangeItems[index.row()]->setName(value.toString());
            break;
        case CodeRole:
            mQuickExchangeItems[index.row()]->setCode(value.toString());
            break;
        case PriceRole:
            mQuickExchangeItems[index.row()]->setPrice(value.toString());
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

QStringList QuickExchangeModel::codeList() const
{
    QStringList rCodeList;
    for (const QuickExchangeItem *i : mQuickExchangeItems)
    {
        rCodeList.append(i->code());
    }
    return rCodeList;
}

void QuickExchangeModel::updatePrice(const QString &code, const QString &price)
{
    for (int i = 0; i < mQuickExchangeItems.size(); ++i)
    {
        if (mQuickExchangeItems.at(i)->code() == code)
        {
            mQuickExchangeItems.at(i)->setPrice(price);
            emit dataChanged(index(i), index(i));
        }
    }
}

QString QuickExchangeModel::imagePath(const QString &code) const
{
    static QString path("qrc:/exchange/%1.png");
    return path.arg(code.toLower());
}

void QuickExchangeModel::add(const QString &name, const QString &code, const QString &price,
                             bool primary)
{
    if (!name.isEmpty() || !price.isEmpty() || !code.isEmpty())
    {
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        mQuickExchangeItems << new QuickExchangeItem(name, code, price, primary);
        endInsertRows();
    }
}

void QuickExchangeModel::clear()
{
    beginResetModel();
    qDeleteAll(mQuickExchangeItems);
    mQuickExchangeItems.clear();
    endResetModel();
}

QHash<int, QByteArray> QuickExchangeModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IconPathRole] = "iconPath";
    roles[NameRole] = "name";
    roles[CodeRole] = "code";
    roles[PriceRole] = "price";
    roles[PrimaryRole] = "primary";
    return roles;
}
