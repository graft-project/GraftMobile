#ifndef CARDMODEL_H
#define CARDMODEL_H

#include <QAbstractListModel>

class CardItem;

class CardModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum CardRoles {
        TitleRole = Qt::UserRole + 1,
        NumberRole,
        HideNumberRole,
        CV2CodeRole,
        MonthRole,
        YearRole
    };

    explicit CardModel(QObject *parent = 0);
    ~CardModel();

    QVector<CardItem *> cards() const;
    QVariant data(const QModelIndex &index, int role) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    int rowCount(const QModelIndex &parent = QModelIndex()) const;

public slots:
    void add(const QString &name, const QString &number, unsigned cv2Code,
             unsigned expirationMonth, unsigned expirationYear);

protected:
    QHash<int, QByteArray> roleNames() const;

private:
    QVector<CardItem *> mCards;
};

#endif // CARDMODEL_H
