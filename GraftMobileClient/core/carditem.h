#ifndef CARDITEM_H
#define CARDITEM_H

#include <QString>

class CardItem
{
public:
    CardItem();
    CardItem(const QString &name, const QString &number, unsigned cv2Code,
             unsigned expirationMonth, unsigned expirationYear);

    QString number() const;
    void setNumber(const QString &value);

    QString hideNumber() const;

    unsigned cv2Code() const;
    void setCV2Code(unsigned value);

    unsigned expirationMonth() const;
    void setExpirationMonth(unsigned value);

    unsigned expirationYear() const;
    void setExpirationYear(unsigned value);

    QString name() const;
    void setName(const QString &value);

private:
    QString mName;
    QString mNumber;
    unsigned mCV2Code;
    unsigned mExpirationMonth;
    unsigned mExpirationYear;
};

#endif // CARDITEM_H
