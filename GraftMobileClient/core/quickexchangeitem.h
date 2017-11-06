#ifndef QUICKEXCHANGEITEM_H
#define QUICKEXCHANGEITEM_H

#include <QString>

class QuickExchangeItem
{
public:
    QuickExchangeItem(QString iconPath, QString name, QString price, QString code, bool isBold = false);

    QString iconPath() const;
    void setIconPath(const QString &iconPath);

    QString name() const;
    void setName(const QString &name);

    QString price() const;
    void setPrice(const QString &price);

    QString code() const;
    void setCode(const QString &code);

    bool isBold() const;
    void setIsBold(bool isBold);

private:
    QString mIconPath;
    QString mName;
    QString mPrice;
    QString mCode;
    bool mIsBold;
};

#endif // QUICKEXCHANGEITEM_H
