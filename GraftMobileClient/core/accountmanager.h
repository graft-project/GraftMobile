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

    void save() const;

private:
    void read();

    QString mPassword;
    QByteArray mAccountData;
};

#endif // ACCOUNTMANAGER_H
