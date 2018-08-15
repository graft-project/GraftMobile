#ifndef CAMERAFILTER_H
#define CAMERAFILTER_H

#include <QAbstractVideoFilter>

class CameraFilter : public QAbstractVideoFilter
{
    Q_OBJECT
public:
    CameraFilter(QObject *parent = nullptr);
    QVideoFilterRunnable *createFilterRunnable() override;

signals:
    void hasPermission(bool result);
};

class CameraRunnable : public QVideoFilterRunnable
{
public:
    CameraRunnable(CameraFilter *filter);
    QVideoFrame run(QVideoFrame *input, const QVideoSurfaceFormat &surfaceFormat,
                    RunFlags flags);

private:
    CameraFilter *mFilter;
};

#endif // CAMERAFILTER_H
