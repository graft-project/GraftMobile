#include "productmodelserializator.h"

#include <QJsonArray>
#include <QJsonObject>
#include <QDebug>
//    JSON структура !!!
//    [
//    {
//       { "title:", "nameProduct"}
//        "cost:", 12
//        "currency", "$"
//        "image", "qur:/picture.png"
//    },
//    {
//        "title:", "nameProduct"
//        "cost:", 12
//        "currency", "$"
//        "image", "qur:/picture.png"
//    },
//    {
//        "title:", "nameProduct"
//        "cost:", 12
//        "currency", "$"
//        "image", "qur:/picture.png"
//    },
//    {
//        "title:", "nameProduct"
//        "cost:", 12
//        "currency", "$"
//        "image", "qur:/picture.png"
//    },
//    ]
ProductModelSerializator::ProductModelSerializator()
{}

QByteArray ProductModelSerializator::serialize(ProductModel *model)
{
    QJsonArray array;
    QVector<ProductItem*> items = model->products();
    for (int i = 0; i < items.count(); ++i)
    {
        ProductItem *item = items.at(i);
        QJsonObject object;
        object.insert("title", item->name());
        object.insert("cost", item->cost());
        object.insert("currency", item->currency());
        object.insert("imagePath", item->imagePath());
        array.append(object);
    }

//    for (int i = 0; i < items.count(); ++i)
//    {
//        ProductItem *item = items.at(i);
//        QJsonObject object;
//        object.insert("cost", item->cost());
//        array.append(object);
//    }

//    for (int i = 0; i < items.count(); ++i)
//    {
//        ProductItem *item = items.at(i);
//        QJsonObject object;
//        object.insert("currency", item->currency());
//        array.append(object);
//    }

//    for (int i = 0; i < items.count(); ++i)
//    {
//        ProductItem *item = items.at(i);
//        QJsonObject object;
//        object.insert("imagePath", item->imagePath());
//        array.append(object);
//    }
    qDebug() << array;



}

//QJsonObject ProductModelSerializator::object() const
//{

//}

//ProductModel *ProductModelSerializator::deserialize(const QByteArray &array)
//{

//}
