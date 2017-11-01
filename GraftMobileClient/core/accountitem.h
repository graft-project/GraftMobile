#ifndef ACCOUNTITEM_H
#define ACCOUNTITEM_H

#include <QString>

class AccountItem
{
public:
    AccountItem();
    AccountItem(const QString &imagePath, const QString &name, const QString &currency, const QString &number);
    QString imagePath() const;
    QString name() const;
    QString currency() const;
    QString number() const;

    void setImagePath(const QString &imagePath);
    void setName(const QString &name);
    void setCurrency(const QString &currency);
    void setNumber(const QString &number);

private:
    QString mImagePath;
    QString mName;
    QString mCurrency;
    QString mNumber;
};
#endif // ACCOUNTITEM_H
