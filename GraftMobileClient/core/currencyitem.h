#ifndef CURRENCYITEM_H
#define CURRENCYITEM_H

#include <QString>

class CurrencyItem
{
public:
    CurrencyItem(const QString &name, const QString &code, const QString &image);

    QString name() const;
    QString code() const;
    QString image() const;

    void setName(const QString &name);
    void setCode(const QString &code);
    void setImage(const QString &image);

private:
    QString mName;
    QString mCode;
    QString mImage;
};

#endif // CURRENCYITEM_H
