#ifndef ACCOUNTMANAGER_H
#define ACCOUNTMANAGER_H

#include <QString>

class AccountManager
{
public:
    AccountManager();

    QString passsword() const;

    void setAccount(const QByteArray &data);
    QByteArray account() const;

    void setAddress(const QString &a);
    QString address() const;

    void setSeed(const QString &seed);
    QString seed() const;

    void save() const;

private:
    void read();

    QString mPassword;
    QByteArray mAccountData;
    QString mAddress;
    QString mSeed;
};

#endif // ACCOUNTMANAGER_H
