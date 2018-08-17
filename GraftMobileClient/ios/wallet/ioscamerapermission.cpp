#include "ioscamerapermission.h"

#include <QTimerEvent>

#include "permissiondelegate.h"

IOSCameraPermission::IOSCameraPermission(QObject *parent)
    : QObject(parent)
    ,mTimer(-1)
{
}

bool IOSCameraPermission::hasPermission()
{
    mTimer = startTimer(50);
    return PermissionDelegate::isCameraAuthorised();
}

void IOSCameraPermission::stopTimer()
{
    killTimer(mTimer);
}

void IOSCameraPermission::timerEvent(QTimerEvent *event)
{
    if (event->timerId() == mTimer)
    {
        if (PermissionDelegate::isCameraAuthorised())
        {
            emit hasCameraPermission(true);
        }
    }
}

