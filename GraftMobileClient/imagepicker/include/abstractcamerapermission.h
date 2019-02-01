#ifndef ABSTRACTCAMERAPERMISSION_H
#define ABSTRACTCAMERAPERMISSION_H

#include "imagepickerlibrary_global.h"

#include <QObject>

class IMAGEPICKERLIBRARYSHARED_EXPORT AbstractCameraPermission : public QObject
{
    Q_OBJECT
public:
    enum CameraPermissionStatus {
        Granted = 0,
        Denied,
        None
    };
    Q_ENUM(CameraPermissionStatus)

    explicit AbstractCameraPermission(QObject *parent = nullptr);
    virtual ~AbstractCameraPermission() = default;

    virtual AbstractCameraPermission::CameraPermissionStatus checkCameraPermission() const;
    virtual void requestCameraPermission() const;

signals:
    void cameraPermissionGranted(int status) const;
};

#endif // ABSTRACTCAMERAPERMISSION_H
