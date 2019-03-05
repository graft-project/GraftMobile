#ifndef BLOGREPRESENTER_H
#define BLOGREPRESENTER_H

#include <QObject>

class QNetworkAccessManager;
class FeedModel;

class BlogRepresenter : public QObject
{
    Q_OBJECT
public:
    explicit BlogRepresenter(QNetworkAccessManager *networkManager, QObject *parent = nullptr);
    ~BlogRepresenter() override;

    void getBlogFeeds() const;

    bool readBlogFeeds() const;

    FeedModel *feedModel() const;

    QString pathToFeeds() const;

signals:
    void blogFeedPathChanged(const QString &path) const;

protected:
    void timerEvent(QTimerEvent *event) override;

private slots:
    void receivedBlogFeeds() const;

private:
    bool parseBlogFeeds(const QByteArray &feeds) const;
    void createShortHTMLFeed() const;
    void createFullHTMLFeed() const;
    QString appDataLocation() const;

private:
    QNetworkAccessManager *mNetworkManager;
    mutable QString mLastBuildDate;
    mutable QString mFeedPath;
    FeedModel *mFeedModel;
    int mRefreshTimer;
};

#endif // BLOGREPRESENTER_H
