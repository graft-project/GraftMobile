#ifndef ABSTRACTCAMERAPERMISSION_H
#define ABSTRACTCAMERAPERMISSION_H

#include <QObject>

class AbstractCameraPermission : public QObject
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

    virtual AbstractCameraPermission::CameraPermissionStatus checkCameraPermission();
    virtual void requestCameraPermission() const;

signals:
    void cameraPermissionGranted(CameraPermissionStatus status) const;
};

#endif // ABSTRACTCAMERAPERMISSION_H
