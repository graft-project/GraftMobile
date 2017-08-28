#include "keygenerator.h"
#include <QUuid>

QString KeyGenerator::generatePID()
{
    return generateUUID();
}

QString KeyGenerator::generateSpendingKey()
{
    return generateUUID();
}

QString KeyGenerator::generateViewKey()
{
    return generateUUID();
}

QString KeyGenerator::generateUUID()
{
    QString lKey = QUuid::createUuid().toString();
    lKey.remove('}');
    lKey.remove('{');
    lKey.remove('-');
    return lKey;
}
