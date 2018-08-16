#include "camerafilter.h"

#ifdef Q_OS_IOS
#include "permissiondelegate.h"
#endif

QVideoFilterRunnable *CameraFilter::createFilterRunnable()
{
    return new CameraRunnable(this);
}

CameraRunnable::CameraRunnable(CameraFilter *filter) : mFilter(filter)
{
}

QVideoFrame CameraRunnable::run(QVideoFrame *input, const QVideoSurfaceFormat &surfaceFormat,
                                QVideoFilterRunnable::RunFlags flags)
{
    Q_UNUSED(surfaceFormat);
    Q_UNUSED(flags);

#ifdef Q_OS_IOS
    if (PermissionDelegate::isCameraAuthorised())
    {
        emit mFilter->hasPermission(true);
    }
#endif

    return *input;
}
