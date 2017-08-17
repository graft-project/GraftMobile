#ifndef PRODUCTMODELSERIALIZATOR_H
#define PRODUCTMODELSERIALIZATOR_H

#include "productmodel.h"
#include <QJsonArray>

class ProductModelSerializator
{
public:
    ProductModelSerializator();
    static QByteArray serialize(ProductModel *model);
    static void deserialize(const QByteArray &array, ProductModel *model);

//    void QJsonArray::append(const QJsonValue &value);

};

#endif // PRODUCTMODELSERIALIZATOR_H
