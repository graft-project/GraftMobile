#ifndef DEFINES_H
#define DEFINES_H

#include <QStandardPaths>

static QString callImageDataPath()
{
    // TODO: QTBUG-65820. QStandardPaths::AppDataLocation is worong ("/") in Android Debug builds
    // For more details see https://bugreports.qt.io/browse/QTBUG-65820?jql=text%20~%20%22QStandardPaths%205.9.4%22
    return QStandardPaths::writableLocation(QStandardPaths::AppDataLocation).append("/ImageProduct/");
}
#endif // DEFINES_H
