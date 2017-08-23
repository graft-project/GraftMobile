#include "productmodelserializator.h"
#include "productmodel.h"
#include "productitem.h"

#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonValue>

QByteArray ProductModelSerializator::serialize(ProductModel *model)
{
    QVector<ProductItem*> items = model->products();
    QJsonArray array;

    for (ProductItem* item : items)
    {
        QJsonObject object;
        object.insert(QStringLiteral("imagePath"), item->imagePath());
        object.insert(QStringLiteral("title"), item->name());
        object.insert(QStringLiteral("cost"), item->cost());
        object.insert(QStringLiteral("currency"), item->currency());
        array.append(object);
    }

    QJsonDocument doc(array);
    return doc.toJson();
}

void ProductModelSerializator::deserialize(const QByteArray &array, ProductModel *model)
{
    Q_ASSERT(model);
    if (model)
    {
        QJsonDocument jsonDoc = QJsonDocument::fromJson(array);
        QJsonArray jsonArray = jsonDoc.array();

        for(int i = 0; i < jsonArray.count(); ++i)
        {
            QJsonObject jsonObject = jsonArray.at(i).toObject();
            model->add(jsonObject.value(QLatin1String("imagePath")).toString(),
                       jsonObject.value(QLatin1String("title")).toString(),
                       jsonObject.value(QLatin1String("cost")).toDouble(),
                       jsonObject.value(QLatin1String("currency")).toString());
        }
    }
}
