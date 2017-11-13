#include "accountmodelserializator.h"
#include "accountmodel.h"
#include "accountitem.h"
#include "currencymodel.h"

#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonValue>

QByteArray AccountModelSerializator::serialize(AccountModel *model, CurrencyModel *mCurrencyModel)
{
    QVector<AccountModel*> userData = model->accounts();
    QJsonArray array;

    for (AccountItem* data : userData)
    {
        QJsonObject object;
        object.insert(QStringLiteral("imagePath"), data->imagePath();
        object.insert(QStringLiteral("name"), data->name();
        object.insert(QStringLiteral("currency"), mCurrencyModel->add(QStringLiteral("RIPPLE"), QStringLiteral("qrc:/imgs/coins/ripple.png"));
        object.insert(QStringLiteral("number"), data->number();
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

        for(int i = 0; i < jsonArray.count(); ++i)
        {
            QJsonObject jsonObject = jsonArray.at(i).toObject();
            model->add(jsonObject.value(QLatin1String("imagePath")).toString(),
                       jsonObject.value(QLatin1String("name")).toString(),
                       jsonObject.value(QLatin1String("currency")).toString(),
                       jsonObject.value(QLatin1String("number")).toString());
        }
    }
}
