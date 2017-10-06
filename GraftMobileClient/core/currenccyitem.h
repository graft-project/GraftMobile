#ifndef CURRENCCYITEM_H
#define CURRENCCYITEM_H

#include <QString>

class CurrencyItem
{
public:
    CurrencyItem(const QString &name, const QString &code);

    QString name() const;
    QString code() const;

    void setName(const QString &name);
    void setCode(const QString code);

private:
    QString mName;
    QString mCode;
};

#endif // CURRENCCYITEM_H
