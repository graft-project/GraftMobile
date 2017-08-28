#ifndef PRODUCTMODELSERIALIZATOR_H
#define PRODUCTMODELSERIALIZATOR_H

#include <QByteArray>

class ProductModel;

class ProductModelSerializator
{
public:
    static QByteArray serialize(ProductModel *model, bool selectedOnly = false);
    static void deserialize(const QByteArray &array, ProductModel *model);
};

#endif // PRODUCTMODELSERIALIZATOR_H
