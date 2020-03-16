#ifndef PAYMENTDETAILS_H
#define PAYMENTDETAILS_H

#include <QString>
#include <QJsonObject>

#include "graftgenericapiv3.h"

// payment details/data to be scanned as qr-code by wallet;
struct PrivatePaymentDetails
{
    GraftGenericAPIv3::NodeAddress posAddress;
    QString blockHash;
    int blockHeight = 0;
    QString paymentId;
    QString key;
    QJsonObject toJson() const;
    static PrivatePaymentDetails fromJson(const QJsonObject &arg);
    bool isValid() const;
};

#endif // PAYMENTDETAILS_H
