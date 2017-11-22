#include "accountmanager.h"
#include "keygenerator.h"

AccountManager::AccountManager()
{
    read();
    if (mPassword.isEmpty())
    {
        mPassword = KeyGenerator::generateUUID(10);
    }
}

QString AccountManager::passsword() const
{
    return mPassword;
}

void AccountManager::setAccount(const QByteArray &data)
{
    mAccountData = data;
}

QByteArray AccountManager::account() const
{
    return mAccountData;
}

void AccountManager::save() const
{

}

void AccountManager::read()
{

}
