#include "blogrepresenter.h"
#include "feedmodel.h"

#include <QNetworkAccessManager>
#include <QSortFilterProxyModel>
#include <QRegularExpression>
#include <QXmlStreamReader>
#include <QStandardPaths>
#include <QNetworkReply>
#include <QTimerEvent>
#include <QDir>

static const QString scBlogCSS("https://www.graft.network/wp-content/themes/graft/style.css?ver=4.9.9");
static const QString scShortFeedHTMLTemplate(":/ShortFeedTemplate.html");
static const QString scFullFeedHTMLTemplate(":/FullFeedTemplate.html");
static const QString scFeedPubDate("ddd, dd MMM yyyy hh:mm:ss +0000");
static const QString scBlogFeeds("https://www.graft.network/feed/");
static const QString scFormattedTime("%formattedTime%");
static const QString scTimeFromRSS("%timeFromRSS%");
static const QString scFeedCSS(":/style.css");
static const QString scContent("%content%");
static const QString scArticle("%ARTICLE%");
static const QString scFeedHTML("%1.html");
static const QString scFeeds("feeds.xml");
static const QString scTitle("%title%");
static const QString scImage("%image%");
static const QString scLink("%link%");
static const QString scCSS("%CSS%");
static const int scRefreshRate{60000 * 60};

BlogRepresenter::BlogRepresenter(QNetworkAccessManager *networkManager, QObject *parent)
    : QObject(parent)
    ,mNetworkManager{networkManager}
    ,mSortModel{new QSortFilterProxyModel(this)}
    ,mFeedModel{new FeedModel(this)}
    ,mRefreshTimer{0}
{
    if (mNetworkManager && mSortModel && mFeedModel)
    {
        mSortModel->setSourceModel(mFeedModel);
        mSortModel->setSortRole(FeedModel::TimeStampRole);
        mSortModel->sort(0, Qt::DescendingOrder);

        mRefreshTimer = startTimer(scRefreshRate);
        readBlogFeeds();
        getBlogFeeds();
    }
}

BlogRepresenter::~BlogRepresenter()
{
}

void BlogRepresenter::getBlogFeeds() const
{
    QNetworkReply *reply = mNetworkManager->get(QNetworkRequest(QUrl(scBlogFeeds)));
    connect(reply, &QNetworkReply::finished,
            this, &BlogRepresenter::receivedBlogFeeds, Qt::UniqueConnection);
}

bool BlogRepresenter::readBlogFeeds() const
{
    bool isFeedsReadSuccess = false;
    QDir lDir(appDataLocation());
    QFile feed(lDir.filePath(scFeeds));
    if (feed.open(QIODevice::ReadOnly))
    {
        isFeedsReadSuccess = parseBlogFeeds(feed.readAll());
        feed.close();
    }
    return isFeedsReadSuccess;
}

QObject *BlogRepresenter::feedModel() const
{
    return mSortModel;
}

QString BlogRepresenter::pathToFeeds() const
{
    return mFeedPath;
}

void BlogRepresenter::timerEvent(QTimerEvent *event)
{
    if (event->timerId() == mRefreshTimer)
    {
        getBlogFeeds();
    }
    QObject::timerEvent(event);
}

void BlogRepresenter::receivedBlogFeeds() const
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    if (reply)
    {
        QByteArray feedRSS = reply->readAll();
        if (!feedRSS.isEmpty())
        {
            QDir lDir(appDataLocation());
            QFile feed(lDir.filePath(scFeeds));
            if (feed.open(QIODevice::WriteOnly))
            {
                feed.write(feedRSS);
                feed.close();
            }
            parseBlogFeeds(feedRSS);
        }
    }
}

bool BlogRepresenter::parseBlogFeeds(const QByteArray &feeds) const
{
    bool isFeedsReadSuccess = false;
    if (!feeds.isEmpty() && mFeedModel)
    {
        QXmlStreamReader feedRss(feeds);
        if (feedRss.readNextStartElement() && feedRss.name() == QStringLiteral("rss"))
        {
            if (feedRss.readNextStartElement() && feedRss.name() == QStringLiteral("channel"))
            {
                while (feedRss.readNextStartElement())
                {
                    if (feedRss.name() == QStringLiteral("lastBuildDate"))
                    {
                        QString lastBuildDate = feedRss.readElementText();

                        if (!lastBuildDate.isEmpty() && lastBuildDate != mLastBuildDate)
                        {
                            mLastBuildDate = lastBuildDate;
                        }
                    }
                    else
                    {
                        if (feedRss.name() == QStringLiteral("item"))
                        {
                            QString description, content, pubDate, title, link;
                            while (feedRss.readNextStartElement())
                            {
                                if (feedRss.name() == QStringLiteral("title"))
                                {
                                    title = feedRss.readElementText();
                                }
                                else if (feedRss.name() == QStringLiteral("link"))
                                {
                                    link = feedRss.readElementText();
                                }
                                else if (feedRss.name() == QStringLiteral("pubDate"))
                                {
                                    pubDate = feedRss.readElementText();
                                }
                                else if (feedRss.name() == QStringLiteral("description"))
                                {
                                    description = feedRss.readElementText();
                                }
                                else if (feedRss.name() == QStringLiteral("encoded"))
                                {
                                    content = feedRss.readElementText();

                                    QString image;
                                    QRegularExpression rx("<img src=\".{8,}\"");
                                    QRegularExpressionMatch match = rx.match(content);
                                    if (match.hasMatch())
                                    {
                                        image = match.captured(0);
                                        image = image.remove(QRegularExpression("<img src=\""));
                                        image = image.mid(0, image.indexOf('"'));
                                    }

                                    if (!link.isEmpty() && !title.isEmpty() && !pubDate.isEmpty() && !content.isEmpty() &&
                                        !description.isEmpty())
                                    {
                                        QDateTime data = QDateTime::fromString(pubDate, scFeedPubDate);
                                        FeedModel::FeedItem *feedItem = new FeedModel::FeedItem(description,
                                                                                                data,
                                                                                                content,
                                                                                                title,
                                                                                                link);
                                        feedItem->mImage = image;
                                        mFeedModel->add(feedItem);
                                    }
                                }
                                else
                                {
                                    feedRss.skipCurrentElement();
                                }
                            }
                        }
                        else
                        {
                            feedRss.skipCurrentElement();
                        }
                    }
                }
            }
            createFullHTMLFeed();
            createShortHTMLFeed();
            isFeedsReadSuccess = true;
        }
    }
    return isFeedsReadSuccess;
}

void BlogRepresenter::createShortHTMLFeed() const
{
    if (mFeedModel)
    {
        QString lHTMLTemplate;
        QString lCSS;

        QFile lHTMLTemplateFile(scShortFeedHTMLTemplate);
        if (lHTMLTemplateFile.open(QIODevice::ReadOnly))
        {
            lHTMLTemplate = lHTMLTemplateFile.readAll();
            lHTMLTemplateFile.close();
        }

        QDir lCSSDir(appDataLocation());
        QFile lCSSTemplateFile(lCSSDir.filePath(scFeedCSS));
        if (lCSSTemplateFile.open(QIODevice::ReadOnly))
        {
            lCSS = lCSSTemplateFile.readAll();
            lCSSTemplateFile.close();
        }

        if (!lHTMLTemplate.isEmpty() && !lCSS.isEmpty())
        {
            QString feed = lHTMLTemplate;
            feed.replace(scCSS, lCSS);

            static const QString scStartArticleTag("<!--");
            static const QString scEndArticleTag("-->");
            const int startArticleTagIndex = lHTMLTemplate.indexOf(scStartArticleTag) +
                                             scStartArticleTag.size();
            const int endArticleTagIndex = lHTMLTemplate.indexOf(scEndArticleTag);
            const QString articleTemplate = lHTMLTemplate.mid(startArticleTagIndex,
                                                              endArticleTagIndex -
                                                              startArticleTagIndex);

            for (int i = 0; i < mFeedModel->rowCount(); ++i)
            {
                FeedModel::FeedItem *item = mFeedModel->itemAt(i);
                if (item)
                {
                    QString formattedFeed = articleTemplate;

                    QModelIndex modelIndex = mFeedModel->index(i);
                    if (modelIndex.isValid())
                    {
                        formattedFeed.replace(scFormattedTime, mFeedModel->data(modelIndex,
                                                                                FeedModel::FormattedDateRole).toString());
                        formattedFeed.replace(scTimeFromRSS, mFeedModel->data(modelIndex,
                                                                              FeedModel::PubDateRole).toString());
                    }
                    formattedFeed.replace(scContent, item->mDescription);
                    formattedFeed.replace(scTitle, item->mTitle);
                    formattedFeed.replace(scImage, item->mImage);
                    formattedFeed.replace(scLink, item->mLink);

                    if (i != mFeedModel->rowCount() - 1)
                    {
                        formattedFeed.append(scArticle);
                    }

                    feed.replace(scArticle, formattedFeed);

                }
            }
            feed = feed.replace(QStringLiteral("Continue reading"), QStringLiteral("Read more"));

            QDir lDir(appDataLocation());
            QFile feedHTML(lDir.filePath(scShortFeedHTMLTemplate.mid(2, scShortFeedHTMLTemplate.size())));
            if (feedHTML.open(QIODevice::WriteOnly))
            {
                mFeedPath = QStringLiteral("file://%1").arg(feedHTML.fileName());
                emit blogFeedPathChanged(mFeedPath);
                feedHTML.write(feed.toUtf8());
                feedHTML.close();
            }
        }
    }
}

void BlogRepresenter::createFullHTMLFeed() const
{
    static const QString scFullFeedPath("blog");
    if (mFeedModel)
    {
        QString lHTMLTemplate;
        QString lCSS;

        QFile lHTMLTemplateFile(scFullFeedHTMLTemplate);
        if (lHTMLTemplateFile.open(QIODevice::ReadOnly))
        {
            lHTMLTemplate = lHTMLTemplateFile.readAll();
            lHTMLTemplateFile.close();
        }

        QDir lDir(appDataLocation());
        lDir.mkdir(scFullFeedPath);
        lDir.cd(scFullFeedPath);

        QDir lCSSDir(appDataLocation());
        QFile lCSSTemplateFile(lCSSDir.filePath(scFeedCSS));
        if (lCSSTemplateFile.open(QIODevice::ReadOnly))
        {
            lCSS = lCSSTemplateFile.readAll();
            lCSSTemplateFile.close();
        }

        if (!lHTMLTemplate.isEmpty() && !lCSS.isEmpty())
        {
            for (int i = 0; i < mFeedModel->rowCount(); ++i)
            {
                QString feed = lHTMLTemplate;
                FeedModel::FeedItem *item = mFeedModel->itemAt(i);
                if (item)
                {
                    QString fullFeedFile = item->mTitle;
                    fullFeedFile = scFeedHTML.arg(fullFeedFile.remove(QRegExp("[\\s\\,\\–\\!\\.\?\\-\\(\\)\\*]")));

                    QFile feedHTML(lDir.filePath(QStringLiteral("%1").arg(fullFeedFile)));
                    if (feedHTML.open(QIODevice::WriteOnly))
                    {
                        item->mFullFeedPath = QStringLiteral("file://%1").arg(feedHTML.fileName());
                        QString parsedDescription = item->mDescription;
                        QString parsedContent = item->mContent;
                        parsedDescription = parsedDescription.remove(parsedDescription.indexOf(QStringLiteral("<p class=\"link-more\">")),
                                                                     parsedDescription.size());
                        item->mContent = parsedContent.remove(parsedContent.indexOf(QStringLiteral("<p>The post ")),
                                                              parsedContent.size());
                        item->mDescription = parsedDescription.replace(item->mLink,
                                                                       item->mFullFeedPath);
                        mFeedModel->updateData(*item, i);

                        feed.replace(scCSS, lCSS);
                        QModelIndex modelIndex = mFeedModel->index(i);
                        if (modelIndex.isValid())
                        {
                            feed.replace(scTimeFromRSS, mFeedModel->data(modelIndex,
                                                                         FeedModel::PubDateRole).toString());
                            feed.replace(scFormattedTime, mFeedModel->data(modelIndex,
                                                                           FeedModel::FormattedDateRole).toString());
                        }
                        feed.replace(scLink, item->mLink);
                        feed.replace(scTitle, item->mTitle);
                        feed.replace(scContent, item->mContent);
                        feed.replace(QStringLiteral("<iframe width=\"560\" height=\"315\""),
                                     QStringLiteral("<iframe width=\"100%\" height=\"200\""));

                        feedHTML.write(feed.toUtf8());
                        feedHTML.close();
                    }
                }
            }
        }
    }
}

QString BlogRepresenter::appDataLocation() const
{
    QString dataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    if (!QFileInfo(dataPath).exists())
    {
        QDir().mkpath(dataPath);
    }
    QDir lDir(dataPath);
    return lDir.path();
}
