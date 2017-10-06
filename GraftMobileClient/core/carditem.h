#ifndef CARDITEM_H
#define CARDITEM_H

#include <QString>

class CardItem
{
public:
    CardItem();
    CardItem(const QString &name, const QString &number, unsigned cv2Code,
             const QString &expirationDate);

    QString number() const;
    void setNumber(const QString &value);

    QString hideNumber() const;

    unsigned cv2Code() const;
    void setCV2Code(unsigned value);

    QString expirationDate() const;
    void setExpirationDate(const QString &value);

    QString name() const;
    void setName(const QString &value);

private:
    QString mName;
    QString mNumber;
    unsigned mCV2Code;
    QString mExpirationDate;
};

#endif // CARDITEM_H
