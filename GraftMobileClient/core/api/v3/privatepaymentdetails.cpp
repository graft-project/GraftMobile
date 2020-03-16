#include "privatepaymentdetails.h"


QJsonObject PrivatePaymentDetails::toJson() const
{
    QJsonObject result;
    result.insert("posAddress", posAddress.toJson());
    result.insert("blockHash", QJsonValue(blockHash));
    result.insert("blockHeight", QJsonValue(blockHeight));
    result.insert("paymentId", QJsonValue(paymentId));
    result.insert("key", QJsonValue(key));
    return result;    
}

PrivatePaymentDetails PrivatePaymentDetails::fromJson(const QJsonObject &arg)
{
    PrivatePaymentDetails result;
    result.posAddress = GraftGenericAPIv3::NodeAddress::fromJson(arg.value("posAddress").toObject());
    result.blockHash = arg.value("blockHash").toString();
    result.blockHeight = arg.value("blockHeight").toInt();
    result.paymentId = arg.value("paymentId").toString();
    result.key = arg.value("key").toString();
    return result;
}

bool PrivatePaymentDetails::isValid() const
{
    return !(posAddress.Id.isEmpty() || posAddress.WalletAddress.isEmpty() || key.isEmpty() || paymentId.isEmpty()
            || blockHash.isEmpty() || blockHeight == 0);
}
