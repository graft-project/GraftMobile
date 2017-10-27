#ifndef DEFINES_H
#define DEFINES_H

#include <QStandardPaths>

static QString callImageDataPath()
{
    return QStandardPaths::writableLocation(QStandardPaths::AppDataLocation).append("/ImageProduct/");
}
#endif // DEFINES_H
