#include "accountmanager.h"
#include "keygenerator.h"
#include <QStandardPaths>
#include <QDataStream>
#include <QFileInfo>
#include <QFile>
#include <QDir>

static const QString scAccountDataFile("account.dat");

AccountManager::AccountManager()
{
    mNetworkType = 0;
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
    // TODO: QTBUG-65820. QStandardPaths::AppDataLocation is worong ("/") in Android Debug builds
    // For more details see https://bugreports.qt.io/browse/QTBUG-65820?jql=text%20~%20%22QStandardPaths%205.9.4%22
    QString dataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    if (!QFileInfo(dataPath).exists())
    {
        QDir().mkpath(dataPath);
    }
    QDir lDir(dataPath);
    QFile lFile(lDir.filePath(scAccountDataFile));
    if (lFile.open(QFile::WriteOnly))
    {
        QDataStream in(&lFile);
        in << mPassword << mAccountData << mAddress << mSeed << mViewKey << mNetworkType;
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
    // TODO: QTBUG-65820. QStandardPaths::AppDataLocation is worong ("/") in Android Debug builds
    // For more details see https://bugreports.qt.io/browse/QTBUG-65820?jql=text%20~%20%22QStandardPaths%205.9.4%22
    QString dataPath = QStandardPaths::locate(QStandardPaths::AppDataLocation,
                                              scAccountDataFile);
    if (!dataPath.isEmpty())
    {
        QFile lFile(dataPath);
        if (lFile.open(QFile::ReadOnly))
        {
            QDataStream in(&lFile);
            in >> mPassword >> mAccountData >> mAddress >> mSeed >> mViewKey >> mNetworkType;
        }
    }
}
