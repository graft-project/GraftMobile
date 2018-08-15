#include "camerafilter.h"
#include <QTimer>

CameraFilter::CameraFilter(QObject *parent) : QAbstractVideoFilter(parent)
{
    QTimer::singleShot(2000, this, [this]() {
        this->hasPermission(false);
    });
}

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

    emit mFilter->hasPermission(!input->size().isEmpty());
    return *input;
}
