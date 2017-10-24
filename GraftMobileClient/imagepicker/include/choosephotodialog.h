#ifndef CHOOSEPHOTODIALOG_H
#define CHOOSEPHOTODIALOG_H

#include <QObject>

class ChoosePhotoDialogPrivate;

class ChoosePhotoDialog : public QObject
{
    Q_OBJECT
    friend class ChoosePhotoDialogPrivate;
public:
    enum DialogType{
        TypePhotoLibrary = 0,
        TypeCamera,
        TypeSavedPhotoAlbums
    };
    Q_ENUM(DialogType)

    explicit ChoosePhotoDialog(DialogType type, QObject *parent = nullptr);
    ~ChoosePhotoDialog();

    DialogType type() const;

    bool allowEditing() const;
    void setAllowEditing(bool allowEditing);

    double compressionQuality() const;
    void setCompressionQuality(double compressionQuality);

    bool isSourceTypeAvailable() const;

    QImage choosenImage() const;

signals:
    void finished(bool);

public slots:
    void show();

private:
    void showPrivate();
    void finish(bool result);

private:
    void setType(const DialogType &type);

private:
    ChoosePhotoDialogPrivate *mDPtrt;
};

#endif // CHOOSEPHOTODIALOG_H
