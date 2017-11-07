#ifndef QUICKEXCHANGEMODEL_H
#define QUICKEXCHANGEMODEL_H

#include <QAbstractListModel>

class QuickExchangeItem;

class QuickExchangeModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum QuickExchangeRole {
        IconPathRole = Qt::UserRole + 1,
        NameRole,
        PriceRole,
        CodeRole,
        PrimaryRole,
    };
    Q_ENUM(QuickExchangeRole)

    explicit QuickExchangeModel(QObject *parent = 0);
    ~QuickExchangeModel();

    QVariant data(const QModelIndex &index, int role) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    int rowCount(const QModelIndex &parent = QModelIndex()) const;

public slots:
    void add(const QString &iconPath, const QString &name, const QString &price,
             const QString &code, bool primary = false);
    void clear();

protected:
    QHash<int, QByteArray> roleNames() const;

private:
    QVector<QuickExchangeItem*> mQuickExchangeItems;
};

#endif // QUICKEXCHANGEMODEL_H
