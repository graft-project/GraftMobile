#ifndef ACCOUNTITEM_H
#define ACCOUNTITEM_H

#include <QString>

class AccountItem
{
public:
    AccountItem();
    AccountItem(const QString &name, const QString &currency, unsigned &number);

    QString name() const;
    QString currency() const;
    unsigned number() const;

    void setName(const QString &name);
    void setCurrency(const QString &currency);
    void setNumber(const unsigned &number);

private:
    QString mName;
    QString mCurrency;
    unsigned mNumber;
};

#endif // ACCOUNTITEM_H
