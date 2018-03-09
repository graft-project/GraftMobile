#ifndef IMAGEPICKER_H
#define IMAGEPICKER_H

#include "choosephotodialog.h"
#include <QObject>
#include <QUrl>

class ImagePicker : public QObject
{
    Q_OBJECT
public:
    explicit ImagePicker(const QString &imagePath, QObject *parent = nullptr);

    Q_INVOKABLE void openCamera();
    Q_INVOKABLE void openGallary();

signals:
    void imageSelected(QUrl path);

private:
    void saveImage(const QImage &image) const;
    void getImage(const ChoosePhotoDialog::DialogType type);
    QString mImagePath;
};
#endif // IMAGEPICKER_H
