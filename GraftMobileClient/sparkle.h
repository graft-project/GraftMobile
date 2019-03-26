#ifndef SPARKLE_H
#define SPARKLE_H

#if defined(QT_NO_DEBUG) && defined(Q_OS_WIN) || defined(Q_OS_MAC) && !defined(Q_OS_IOS)
#include <QSettings>

#include "sparkleupdater.h"
#endif

#if defined(QT_NO_DEBUG) && defined(Q_OS_WIN) || defined(Q_OS_MAC) && !defined(Q_OS_IOS)
#ifdef Q_OS_WIN
void exitFunction()
{
    QSettings s;
    QDir appDir(qApp->applicationDirPath());
    appDir.cdUp();
    s.setValue("InstallLocation", QDir::toNativeSeparators(appDir.absolutePath()));
    std::exit(0);
}
#endif

#ifdef POS_BUILD
static const QString scSparkleFeedUrl("https://raw.githubusercontent.com/graft-project/GraftMobile/master/GraftMobileClient/pos_update.xml");
#elif WALLET_BUILD
static const QString scSparkleFeedUrl("https://raw.githubusercontent.com/graft-project/GraftMobile/master/GraftMobileClient/wallet_update.xml");
#endif
#endif

void runSparkleUpdater()
{
#if defined(QT_NO_DEBUG) && defined(Q_OS_WIN) || defined(Q_OS_MAC) && !defined(Q_OS_IOS)
    SparkleUpdater::instance()->setLanguage(QStringLiteral("eng"));
    SparkleUpdater::instance()->setAppInfo(qApp->organizationName(), qApp->applicationName(), qApp->applicationVersion());
#ifdef Q_OS_WIN
    SparkleUpdater::instance()->setWillCloseCallback(&exitFunction);
#endif
    SparkleUpdater::instance()->setAutoChecksUpdates(true);
    SparkleUpdater::instance()->setFeedUrl(QUrl(scSparkleFeedUrl));
    SparkleUpdater::instance()->init();
    SparkleUpdater::instance()->checkForUpdates(true);
#endif
}

void stopSparkleUpdater()
{
#if defined(QT_NO_DEBUG) && defined(Q_OS_WIN) || defined(Q_OS_MAC) && !defined(Q_OS_IOS)
    SparkleUpdater::instance()->clean();
#endif
}

#endif // SPARKLE_H
