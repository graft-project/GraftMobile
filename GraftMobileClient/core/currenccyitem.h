#ifndef CURRENCCYITEM_H
#define CURRENCCYITEM_H

#include <QString>

class CurrencyItem
{
public:
    CurrencyItem(const QString &name, const int &code);

    QString name() const;
    int code() const;

private:
    QString mName;
    int mCode;
};

#endif // CURRENCCYITEM_H
