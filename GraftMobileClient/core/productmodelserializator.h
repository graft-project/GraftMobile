#ifndef PRODUCTMODELSERIALIZATOR_H
#define PRODUCTMODELSERIALIZATOR_H

#include "productmodel.h"

class ProductModelSerializator
{
public:
    ProductModelSerializator();

    static QByteArray serialize(ProductModel *model);
//    static ProductModel *deserialize(const QByteArray &array);

//    void QJsonArray::append(const QJsonValue &value);

};

#endif // PRODUCTMODELSERIALIZATOR_H
