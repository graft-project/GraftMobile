#include "carditem.h"
#include "cardmodel.h"

CardModel::CardModel(QObject *parent) : QAbstractListModel(parent)
{
}

CardModel::~CardModel()
{
    qDeleteAll(mCards);
}

QVector<CardItem *> CardModel::cards() const
{
    return mCards;
}

QVariant CardModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= mCards.count())
    {
        return QVariant();
    }

    CardItem *cardItem = mCards[index.row()];

    switch (role) {
    case TitleRole:
        return cardItem->name();
    case NumberRole:
        return cardItem->number();
    case HideNumberRole:
        return cardItem->hideNumber();
    case CV2CodeRole:
        return cardItem->cv2Code();
    case DateRole:
        return cardItem->expirationDate();
    default:
        return QVariant();
    }
}

bool CardModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (index.isValid() && value.isValid() && data(index, role) != value)
    {
        switch (role)
        {
        case TitleRole:
            mCards[index.row()]->setName(value.toString());
            break;
        case NumberRole:
            mCards[index.row()]->setNumber(value.toString());
            break;
        case CV2CodeRole:
            mCards[index.row()]->setCV2Code(value.toUInt());
            break;
        case DateRole:
            mCards[index.row()]->setExpirationDate(value.toString());
            break;
        default:
            break;
        }
        emit dataChanged(index, index, QVector<int>() << role);
        return true;
    }
    return false;
}

int CardModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return mCards.count();
}

void CardModel::add(const QString &name, const QString &number, unsigned cv2Code,
                    const QString &expirationDate)
{
    if ((number.size() == 16 && (cv2Code > 99 && cv2Code < 1000)))
    {
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        mCards.append(new CardItem(name, number, cv2Code, expirationDate));
        endInsertRows();
    }
}

QHash<int, QByteArray> CardModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TitleRole] = "cardName";
    roles[NumberRole] = "cardNumber";
    roles[HideNumberRole] = "cardHideNumber";
    roles[CV2CodeRole] = "cardCV2Code";
    roles[DateRole] = "cardExpirationDate";
    return roles;
}
