#ifndef QUICKEXCHANGEITEM_H
#define QUICKEXCHANGEITEM_H

#include <QString>

class QuickExchangeItem
{
public:
    explicit QuickExchangeItem(const QString &name, const QString &code,
                               const QString &price = QString(), bool primary = false);

    QString name() const;
    void setName(const QString &name);

    QString code() const;
    void setCode(const QString &code);

    QString price() const;
    void setPrice(const QString &price);

    bool primary() const;
    void setPrimary(bool primary);

private:
    QString mName;
    QString mPrice;
    QString mCode;
    bool mPrimary;
};

#endif // QUICKEXCHANGEITEM_H
