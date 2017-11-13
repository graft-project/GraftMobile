#include "accountmodelserializator.h"
#include "accountmodel.h"
#include "accountitem.h"

#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonValue>

QByteArray AccountModelSerializator::serialize(AccountModel *model)
{
    QVector<AccountModel*> userData = model->accounts();
    QJsonArray array;

    for (AccountItem* data : userData)
    {
        QJsonObject object;
        object.insert(QStringLiteral("type"), data->currency();
        object.insert(QStringLiteral("imagePath"), data->imagePath();
        object.insert(QStringLiteral("accountName"), data->name();
        object.insert(QStringLiteral("accountNumber"), data->number();
        array.append(object);
    }

    QJsonDocument doc(array);
    return doc.toJson();
}

void AccountModelSerializator::deserialize(const QByteArray &array, AccountModel *model)
{

}
