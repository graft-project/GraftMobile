#include "keygenerator.h"
#include <QUuid>

QString KeyGenerator::generatePID()
{
    return generateUUID(8);
}

QString KeyGenerator::generateSpendingKey()
{
    return generateUUID(16);
}

QString KeyGenerator::generateViewKey()
{
    return generateUUID(16);
}

QString KeyGenerator::generateUUID(int length)
{
    QString lKey = QUuid::createUuid().toString();
    lKey.remove('}');
    lKey.remove('{');
    lKey.remove('-');
    if (length > 0)
    {
        return lKey.remove(length, lKey.length() - length);
    }
    return lKey;
}
