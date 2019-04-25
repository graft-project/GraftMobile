#ifndef BLOGREADER_H
#define BLOGREADER_H

#include <QObject>

class QNetworkAccessManager;
class QSortFilterProxyModel;
class FeedModel;

class BlogReader : public QObject
{
    Q_OBJECT
public:
    explicit BlogReader(QNetworkAccessManager *networkManager, QObject *parent = nullptr);
    ~BlogReader() override;

    bool readBlogFeeds() const;

    Q_INVOKABLE void getBlogFeeds() const;

    Q_INVOKABLE QObject *feedModel() const;

protected:
    void timerEvent(QTimerEvent *event) override;

private slots:
    void receivedBlogFeeds() const;

private:
    bool parseBlogFeeds(const QByteArray &feeds) const;
    void createFullHTMLFeed() const;
    QString appDataLocation() const;
    void refreshFeeds();

private:
    QNetworkAccessManager *mNetworkManager;
    QSortFilterProxyModel *mSortModel;
    mutable QString mLastBuildDate;
    FeedModel *mFeedModel;
    int mRefreshTimer;
};

#endif // BLOGREADER_H
