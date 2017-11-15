#include "currencymodel.h"
#include "currencyitem.h"

CurrencyModel::CurrencyModel(QObject *parent) : QAbstractListModel(parent)
{}

CurrencyModel::~CurrencyModel()
{
    qDeleteAll(mCurrency);
}

int CurrencyModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return mCurrency.count();
}

QVariant CurrencyModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= mCurrency.count())
    {
        return QVariant();
    }
    CurrencyItem *currency = mCurrency[index.row()];
    Q_ASSERT(currency);
    switch (role)
    {
    case TitleRole:
        return currency->name();
    case CodeRole:
        return currency->code();
    case ImageRole:
        return currency->image();
    default:
        return QVariant();
    }
}

bool CurrencyModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (index.isValid() && value.isValid() && data(index, role) != value)
    {
        switch (role)
        {
        case TitleRole:
            mCurrency[index.row()]->setName(value.toString());
            break;
        case CodeRole:
            mCurrency[index.row()]->setCode(value.toString());
            break;
        case ImageRole:
            mCurrency[index.row()]->setImage(value.toString());
        default:
            break;
        }
        emit dataChanged(index, index, QVector<int>() << role);
        return true;
    }
    return false;
}

int CurrencyModel::indexOf(const QString &code) const
{
    for (int i = 0; i < mCurrency.size(); ++i)
    {
        if (mCurrency.at(i)->code() == code)
        {
            return i;
        }
    }
    return -1;
}

QString CurrencyModel::codeOf(const QString &name) const
{
    for (int i = 0; i < mCurrency.size(); ++i)
    {
        if (mCurrency.at(i)->name() == name)
        {
            return mCurrency.at(i)->code();
        }
    }
    return QString();
}

QString CurrencyModel::imageOf(const QString &name) const
{
    for ( int i = 0; i < mCurrency.size(); ++i)
    {
        if (mCurrency.at(i)->name() == name)
        {
            return mCurrency.at(i)->image();
        }
    }
    return QString();
}

void CurrencyModel::add(const QString &name, const QString &code, const QString &image)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    mCurrency << new CurrencyItem(name, code, image);
    endInsertRows();
}

QHash<int, QByteArray> CurrencyModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TitleRole] = "name";
    roles[CodeRole] = "code";
    roles[ImageRole] = "image";
    return roles;
}
