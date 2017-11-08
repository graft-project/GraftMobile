#ifndef QUICKEXCHANGEITEM_H
#define QUICKEXCHANGEITEM_H

#include <QString>

class QuickExchangeItem
{
public:
    explicit QuickExchangeItem(const QString &iconPath, const QString &name, const QString &code,
                               const QString &price = "0", bool primary = false);

    QString iconPath() const;
    void setIconPath(const QString &iconPath);

    QString name() const;
    void setName(const QString &name);

    QString code() const;
    void setCode(const QString &code);

    QString price() const;
    void setPrice(const QString &price);

    bool primary() const;
    void setPrimary(bool primary);

private:
    QString mIconPath;
    QString mName;
    QString mPrice;
    QString mCode;
    bool mPrimary;
};

#endif // QUICKEXCHANGEITEM_H
