#include "accountmanager.h"
#include "keygenerator.h"
#include <QStandardPaths>
#include <QDataStream>
#include <QFileInfo>
#include <QFile>
#include <QDir>

static const QString scAccountDataFile("account.dat%1");

AccountManager::AccountManager()
{
    mNetworkType = 0;
    mLastVersion = Version1;
    read();
}

void AccountManager::setNetworkType(int network)
{
    if (mNetworkType != network)
    {
        mNetworkType = network;
        save();
    }
}

int AccountManager::networkType() const
{
    return mNetworkType;
}

void AccountManager::setPassword(const QString &passsword)
{
    if (mPassword != passsword)
    {
        mPassword = passsword;
        save();
    }
}

QString AccountManager::passsword() const
{
    return mPassword;
}

void AccountManager::setAccount(const QByteArray &data)
{
    if (mAccountData != data)
    {
        mAccountData = data;
        save();
    }
}

QByteArray AccountManager::account() const
{
    return mAccountData;
}

void AccountManager::setAddress(const QString &a)
{
    if (mAddress != a)
    {
        mAddress = a;
        save();
    }
}

QString AccountManager::address() const
{
    return mAddress;
}

void AccountManager::setViewKey(const QString &key)
{
    if (mViewKey != key)
    {
        mViewKey = key;
        save();
    }
}

QString AccountManager::viewKey() const
{
    return mViewKey;
}

void AccountManager::setSeed(const QString &seed)
{
    if (mSeed != seed)
    {
        mSeed = seed;
        save();
    }
}

QString AccountManager::seed() const
{
    return mSeed;
}

void AccountManager::save() const
{
    QString dataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    if (!QFileInfo(dataPath).exists())
    {
        QDir().mkpath(dataPath);
    }
    QDir lDir(dataPath);
    QFile lFile(lDir.filePath(scAccountDataFile.arg(mLastVersion)));
    if (lFile.open(QFile::WriteOnly))
    {
        QByteArray data;
        QDataStream in(&data, QIODevice::WriteOnly);
        in << mPassword << mAccountData << mAddress << mSeed << mViewKey << mNetworkType;
        lFile.write(qCompress(data));
    }
}

void AccountManager::clearData()
{
    mAccountData.clear();
    mPassword.clear();
    mViewKey.clear();
    mAddress.clear();
    mNetworkType = 0;
    mSeed.clear();
    save();
}

void AccountManager::read()
{
    QString dataPath = accountDataFile();
    if (!dataPath.isEmpty())
    {
        AccountVersion currentVersion = versionOf(dataPath);
        QFile lFile(dataPath);
        if (lFile.open(QFile::ReadOnly))
        {
            QByteArray fileData = lFile.readAll();
            QByteArray data = currentVersion == Version0 ? fileData : qUncompress(fileData);
            QDataStream in(data);
            in >> mPassword >> mAccountData >> mAddress >> mSeed >> mViewKey >> mNetworkType;
        }
        if (currentVersion != mLastVersion)
        {
            lFile.remove();
            save();
        }
    }
}

QString AccountManager::accountDataFile() const
{
    static QStringList versions{QString::number(Version1), ""};
    QString dataPath;
    for (QString version : versions)
    {
        dataPath = QStandardPaths::locate(QStandardPaths::AppDataLocation,
                                          scAccountDataFile.arg(version));
        if (!dataPath.isEmpty())
        {
            break;
        }
    }
    return dataPath;
}

AccountManager::AccountVersion AccountManager::versionOf(const QString &filename) const
{
    QFileInfo info(filename);
    QString extension = info.suffix();
    extension.replace(QLatin1String("dat"), QLatin1String());
    if (extension.isEmpty())
    {
#if defined(Q_OS_IOS) || defined(Q_OS_ANDROID)
        return Version0;
#elif defined(Q_OS_WIN) || defined(Q_OS_MAC) || defined(Q_OS_LINUX)
        return Version1;
#endif
    }
    return static_cast<AccountVersion>(extension.toInt());
}
