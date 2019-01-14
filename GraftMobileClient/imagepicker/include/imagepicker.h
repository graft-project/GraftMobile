#ifndef IMAGEPICKER_H
#define IMAGEPICKER_H

#include "choosephotodialog.h"

#include <QObject>
#include <QUrl>

#ifdef Q_OS_ANDROID
class AndroidPermission;
#endif

class ImagePicker : public QObject
{
    Q_OBJECT
public:
    explicit ImagePicker(const QString &imagePath, QObject *parent = nullptr);

    Q_INVOKABLE void openCamera() const;
    Q_INVOKABLE void openGallary() const;

    Q_INVOKABLE bool hasCameraPermission() const;
    Q_INVOKABLE void requestCameraPermission() const;

signals:
    void imageSelected(QUrl path) const;
    void cameraAccessed(bool result) const;

private slots:
    void unlockCamera(bool result) const;

private:
    void saveImage(const QImage &image) const;
    void getImage(ChoosePhotoDialog::DialogType type) const;
    QString mImagePath;

#ifdef Q_OS_ANDROID
    AndroidPermission *mAndroidPermission;
#endif

};
#endif // IMAGEPICKER_H
