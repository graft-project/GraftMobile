#include "accountmodelserializator.h"
#include "accountmodel.h"
#include "accountitem.h"

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonValue>

QByteArray AccountModelSerializator::serialize(AccountModel *model)
{
    QVector<AccountItem*> accountData = model->accounts();
    QJsonArray array;

    for (AccountItem* data : accountData)
    {
        QJsonObject object;
        object.insert(QStringLiteral("imagePath"), data->imagePath());
        object.insert(QStringLiteral("name"), data->name());
        object.insert(QStringLiteral("currency"), data->currency());
        object.insert(QStringLiteral("number"), data->number());
        array.append(object);
    }

    QJsonDocument doc(array);
    return doc.toJson();
}

void AccountModelSerializator::deserialize(const QByteArray &array, AccountModel *model)
{
    Q_ASSERT(model);
    if (model && !array.isEmpty())
    {
        QJsonDocument jsonDoc = QJsonDocument::fromJson(array);
        QJsonArray jsonArray = jsonDoc.array();

        for (int i = 0; i < jsonArray.count(); ++i)
        {
            QJsonObject jsonObject = jsonArray.at(i).toObject();
            model->add(jsonObject.value(QLatin1String("imagePath")).toString(),
                       jsonObject.value(QLatin1String("name")).toString(),
                       jsonObject.value(QLatin1String("currency")).toString(),
                       jsonObject.value(QLatin1String("number")).toString());
        }
    }
}
