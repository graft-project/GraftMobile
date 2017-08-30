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
    if (index.row() < 0 || index.row() >= mCards.count() || !index.isValid())
    {
        return QVariant();
    }

    CardItem *cardItem = mCards[index.row()];

    switch (role) {
    case TitleRole:
        if (cardItem->getNumber().at(0) == QChar('5'))
        {
            return "VISA";
        }
        else if (cardItem->getNumber().at(0) == QChar('4'))
        {
            return "MasterCard";
        }
        else if (cardItem->getNumber().at(0) == QChar('3') &&
                 cardItem->getNumber().at(0) == QChar('0'))
        {
            return "AE";
        }
        else
        {
            return "Graft";
        }
    case NumberRole:
        return cardItem->getNumber();
    case HideNumberRole:
        return cardItem->getHideNumber();
    case CV2CodeRole:
        return cardItem->getCV2Code();
    case MonthRole:
        return cardItem->getExpirationMonth();
    case YearRole:
        return cardItem->getExpirationYear();
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
        case MonthRole:
            mCards[index.row()]->setExpirationMonth(value.toUInt());
            break;
        case YearRole:
            mCards[index.row()]->setExpirationYear(value.toUInt());
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

void CardModel::add(const QString &number, const unsigned &cv2Code,
                    const unsigned &expirationMonth, const unsigned &expirationYear)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    mCards.append(new CardItem(number, cv2Code, expirationMonth, expirationYear));
    endInsertRows();
}

QHash<int, QByteArray> CardModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TitleRole] = "cardName";
    roles[NumberRole] = "cardNumber";
    roles[HideNumberRole] = "cardHideNumber";
    roles[CV2CodeRole] = "cardCV2Code";
    roles[MonthRole] = "cardExpirationMonth";
    roles[YearRole] = "cardExpirationYear";
    return roles;
}
