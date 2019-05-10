#include "androidtools.h"

#include <QNetworkRequest>
#include <QVersionNumber>
#include <QNetworkReply>

#ifdef Q_OS_ANDROID
#include <QAndroidJniEnvironment>
#include <QtAndroid>
#endif

static const QString scDivContainsAppVersionRegExp(R"(<span class="htlgb"><div class="IQ1z0d"><span class="htlgb">%1</span></div></span>)");
static const QString scCheckUpdateLink("https://play.google.com/store/apps/details?id=%1");
static const QVersionNumber scVersionNumber(MAJOR_VERSION, MINOR_VERSION, BUILD_VERSION);
static const QString scAppVersionRegExp(R"(\d{1,2}\.\d{1,2}\.\d{1,2})");
static const QString scUpdateLink("market://details?id=%1");

AndroidTools::AndroidTools(QObject *parent)
    : AbstractDeviceTools(parent)
    ,mAppVersion{scVersionNumber.toString()}
{
#ifdef Q_OS_ANDROID
    QAndroidJniObject appContext = QtAndroid::androidContext();
    QAndroidJniObject packageManager = appContext.callObjectMethod("getPackageManager",
                                                                   "()Landroid/content/pm/PackageManager;");
    QAndroidJniObject packageNameStr = appContext.callObjectMethod("getPackageName",
                                                                   "()Ljava/lang/String;");
    mPackageName = packageNameStr.toString();
#endif
}

AndroidTools::~AndroidTools()
{
}

bool AndroidTools::isSpecialTypeDevice() const
{
    return false;
}

double AndroidTools::bottomNavigationBarHeight() const
{
    return 0.0;
}

double AndroidTools::statusBarHeight() const
{
    return 0.0;
}

void AndroidTools::checkAppVersion() const
{
    if (mNetworkManager)
    {
        QNetworkReply *reply = mNetworkManager->get(QNetworkRequest(QUrl(scCheckUpdateLink.arg(mPackageName))));
        if (reply)
        {
            connect(reply, &QNetworkReply::finished,
                    this, &AndroidTools::processCheckAppVersion, Qt::UniqueConnection);
        }
    }
}

void AndroidTools::processCheckAppVersion() const
{
    QString googlePlayAppVersion;
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    if (reply)
    {
        QString html(reply->readAll());
        reply->deleteLater();
        reply = nullptr;
        if (!html.isEmpty())
        {
            QRegExp regExp(scDivContainsAppVersionRegExp.arg(scAppVersionRegExp));
            regExp.indexIn(html);
            for (const auto &capturedText: regExp.capturedTexts())
            {
                QRegExp newestVersionRegExp(scAppVersionRegExp);
                newestVersionRegExp.indexIn(capturedText);
                QStringList appVerionList = newestVersionRegExp.capturedTexts();
                if (!appVerionList.isEmpty())
                {
                    googlePlayAppVersion = appVerionList.at(0);
                }
            }
        }
    }
    if (googlePlayAppVersion > mAppVersion)
    {
        emit updateNeeded(scUpdateLink.arg(mPackageName), googlePlayAppVersion);
    }
}
