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
    read();
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
    QFile lFile(lDir.filePath(scAccountDataFile));
    if (lFile.open(QFile::WriteOnly))
    {
        QDataStream in(&lFile);
        in << mPassword << mAccountData << mAddress << mSeed << mViewKey;
    }
}

void AccountManager::read()
{
    QString dataPath = QStandardPaths::locate(QStandardPaths::AppDataLocation,
                                              scAccountDataFile);
    if (!dataPath.isEmpty())
    {
        QFile lFile(dataPath);
        if (lFile.open(QFile::ReadOnly))
        {
            QDataStream in(&lFile);
            in >> mPassword >> mAccountData >> mAddress >> mSeed >> mViewKey;
        }
    }
}
