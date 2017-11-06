#ifndef QUICKEXCHANGEITEM_H
#define QUICKEXCHANGEITEM_H

#include <QString>

class QuickExchangeItem
{
public:
    explicit QuickExchangeItem(QString iconPath, QString name, QString price, QString code, bool primary = false);

    QString iconPath() const;
    void setIconPath(const QString &iconPath);

    QString name() const;
    void setName(const QString &name);

    QString price() const;
    void setPrice(const QString &price);

    QString code() const;
    void setCode(const QString &code);

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
