#ifndef CARDITEM_H
#define CARDITEM_H

#include <QString>

class CardItem
{
public:
    CardItem();
    CardItem(const QString &number, const unsigned &cv2Code,
             const unsigned &expirationMonth, const unsigned &expirationYear);

    QString getNumber() const;
    void setNumber(const QString &value);

    QString getHideNumber() const;

    unsigned getCV2Code() const;
    void setCV2Code(unsigned value);

    unsigned getExpirationMonth() const;
    void setExpirationMonth(unsigned value);

    unsigned getExpirationYear() const;
    void setExpirationYear(unsigned value);

    QString getName() const;
    void setName(const QString &value);

private:
    QString mName;
    QString mNumber;
    unsigned mCV2Code;
    unsigned mExpirationMonth;
    unsigned mExpirationYear;
};

#endif // CARDITEM_H
