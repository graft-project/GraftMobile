#ifndef IMAGEPICKER_H
#define IMAGEPICKER_H

#include <QObject>
#include <QUrl>

#include "abstractcamerapermission.h"
#include "choosephotodialog.h"

class ImagePicker : public QObject
{
    Q_OBJECT
public:
    explicit ImagePicker(const QString &imagePath, QObject *parent = nullptr);

    Q_INVOKABLE void openCamera() const;
    Q_INVOKABLE void openGallary() const;

    Q_INVOKABLE int hasCameraPermission() const;
    Q_INVOKABLE void requestCameraPermission() const;

signals:
    void imageSelected(QUrl path) const;
    void cameraPermissionGranted(int result) const;

private slots:
    void unlockCamera(int result) const;

private:
    void saveImage(const QImage &image) const;
    void getImage(ChoosePhotoDialog::DialogType type) const;
    void registerRVCameraPermission() const;

    QString mImagePath;
    AbstractCameraPermission *mCameraPermission;
};

#endif // IMAGEPICKER_H
