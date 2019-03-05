#ifndef FEEDMODEL_H
#define FEEDMODEL_H

#include <QAbstractListModel>

class FeedModel : public QAbstractListModel
{
    Q_OBJECT
public:
    struct FeedItem
    {
        QString	mFormattedDate;
        QString mFullFeedPath;
        QString	mDescription;
        QString	mPubDate;
        QString	mContent;
        QString	mTitle;
        QString	mImage;
        QString	mLink;

        FeedItem(const QString &description, const QString pubDate, const QString &content,
                 const QString &title, const QString &link)
            : mDescription{description}, mPubDate{pubDate}, mContent{content}, mTitle{title},
              mLink{link}
        {
        }
    };

    enum FeedRoles {
        DescriptionRole = Qt::UserRole + 1,
        FormattedDateRole,
        FullFeedPathRole,
        PubDateRole,
        ContentRole,
        TitleRole,
        ImageRole,
        LinkRole
    };
    Q_ENUM(FeedRoles)

    explicit FeedModel(QObject *parent = nullptr);
    ~FeedModel() override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QStringList links() const;

    bool updateData(const FeedItem &feed, int index);
    FeedItem *itemAt(int index) const;

public slots:
    void add(FeedItem *feed);

protected:
    QHash<int, QByteArray> roleNames() const override;

private:
    QVector<FeedItem*> mFeeds;
};

#endif // FEEDMODEL_H
