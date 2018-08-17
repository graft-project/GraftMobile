#include "ioscamerapermission.h"
#include "permissiondelegate.h"

#include <QTimerEvent>

IOSCameraPermission::IOSCameraPermission(QObject *parent)
    : QObject(parent)
    ,mTimer(-1)
{
}

bool IOSCameraPermission::hasPermission()
{
    if (!PermissionDelegate::isCameraAuthorised())
    {
        mTimer = startTimer(50);
        return false;
    }
    return true;
}

void IOSCameraPermission::stopTimer()
{
    killTimer(mTimer);
}

void IOSCameraPermission::timerEvent(QTimerEvent *event)
{
    if ((event->timerId() == mTimer) && PermissionDelegate::isCameraAuthorised())
    {
        emit hasCameraPermission(true);
    }
}

