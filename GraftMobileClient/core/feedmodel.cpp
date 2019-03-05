#include "feedmodel.h"

FeedModel::FeedModel(QObject *parent) : QAbstractListModel(parent)
{
}

FeedModel::~FeedModel()
{
}

QVariant FeedModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= mFeeds.count())
    {
        return QVariant();
    }

    FeedItem *feed = mFeeds.at(index.row());
    Q_ASSERT(feed);
    switch (role)
    {
    case FormattedDateRole:
        return feed->mFormattedDate;
    case FullFeedPathRole:
        return feed->mFullFeedPath;
    case DescriptionRole:
        return feed->mDescription;
    case PubDateRole:
        return feed->mPubDate;
    case ContentRole:
        return feed->mContent;
    case TitleRole:
        return feed->mTitle;
    case ImageRole:
        return feed->mImage;
    case LinkRole:
        return feed->mLink;
    default:
        return QVariant();
    }
}

int FeedModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return mFeeds.count();
}

QStringList FeedModel::links() const
{
    QStringList links;
    for (const auto &feed : mFeeds)
    {
        links.append(feed->mLink);
    }
    return links;
}

bool FeedModel::updateData(const FeedModel::FeedItem &feed, int index)
{
    FeedModel::FeedItem *item = itemAt(index);
    if (item)
    {
        item->mFormattedDate = feed.mFormattedDate;
        item->mFullFeedPath = feed.mFullFeedPath;
        item->mDescription = feed.mDescription;
        item->mPubDate = feed.mPubDate;
        item->mContent = feed.mContent;
        item->mTitle = feed.mTitle;
        item->mImage = feed.mImage;
        item->mLink = feed.mLink;

        QModelIndex modelIndex = this->index(index);
        emit dataChanged(modelIndex, modelIndex);
        return true;
    }
    return false;
}

FeedModel::FeedItem *FeedModel::itemAt(int index) const
{
    if (index >= 0 && index < mFeeds.count())
    {
        return mFeeds.at(index);
    }
    return nullptr;
}

void FeedModel::add(FeedModel::FeedItem *feed)
{
    if (feed && !links().contains(feed->mLink))
    {
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        mFeeds.append(feed);
        endInsertRows();
    }
}

QHash<int, QByteArray> FeedModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[FormattedDateRole] = "formattedDate";
    roles[FullFeedPathRole] = "fullFeedPath";
    roles[DescriptionRole] = "description";
    roles[PubDateRole] = "pubDate";
    roles[ContentRole] = "content";
    roles[TitleRole] = "title";
    roles[ImageRole] = "image";
    roles[LinkRole] = "link";
    return roles;
}
