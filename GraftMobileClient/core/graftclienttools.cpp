#include "graftclienttools.h"

#include <QRegularExpressionMatch>
#include <QRegularExpression>
#include <QGuiApplication>
#include <QHostAddress>
#include <QClipboard>
#include <QUrl>

// TODO: QTBUG-74076. The application is crash or will hang when request permission, after the
// native Android keyboard. For more details see https://bugreports.qt.io/browse/QTBUG-74076
#ifdef Q_OS_ANDROID
static const QString scCameraPermission("android.permission.CAMERA");
static const QString scBackCamera("1");
#endif

#ifdef Q_OS_ANDROID
#include <QAndroidJniEnvironment>
#endif

GraftClientTools::GraftClientTools(QObject *parent)
    : QObject(parent)
{
}

bool GraftClientTools::isValidIp(const QString &ip)
{
    QHostAddress validateIp;
    return validateIp.setAddress(ip);
}

bool GraftClientTools::isValidUrl(const QString &urlAddress)
{
    return QUrl(urlAddress, QUrl::StrictMode).isValid();
}

QString GraftClientTools::wideSpacingSimplify(const QString &seed)
{
    return seed.simplified();
}

void GraftClientTools::copyToClipboard(const QString &data)
{
    QClipboard *clipboard = QGuiApplication::clipboard();
    clipboard->setText(data);
}

QString GraftClientTools::dotsRemove(const QString &message)
{
    return QString(message).remove(QChar('.'), Qt::CaseInsensitive);
}

GraftClientTools::NetworkType GraftClientTools::networkType(const QString &text)
{
    if (!text.isEmpty())
    {
        if (QRegularExpressionMatch(QRegularExpression("http://").match(text, 0)).hasMatch())
        {
            return NetworkType::Http;
        }
        else if (QRegularExpressionMatch(QRegularExpression("https://").match(text, 0)).hasMatch())
        {
            return NetworkType::Https;
        }
    }
    return NetworkType::None;
}

void GraftClientTools::requestCameraPermission(GraftClientTools::Buttons button) const
{
#ifdef Q_OS_ANDROID
    // Beginning with Android 6.0 (API level 23), users can revoke permissions from any app at any
    // time, but those solution is not working for android 4.2.2 and others < 5.0.0
    if (QtAndroid::androidSdkVersion() >= 23)
    {
        QtAndroid::requestPermissions(QStringList() << scCameraPermission,
                                      std::bind(&GraftClientTools::permissionCallback,
                                      this, std::placeholders::_1, button));
    }
    else
    {
        emit cameraPermissionGranted(CameraPermissionStatus::Granted, button);
    }
#else
    Q_UNUSED(button);
#endif
}

int GraftClientTools::cameraOrientation() const
{
    int result = -1;
#ifdef Q_OS_ANDROID
    // Start with Android 5.0 (API level 21) have been added to the camera characteristics orientation field.
    if (QtAndroid::androidSdkVersion() >= 21)
    {
        QAndroidJniObject service = QAndroidJniObject::fromString("camera");
        QAndroidJniObject activity =
                QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative",
                                                          "activity",
                                                          "()Landroid/app/Activity;");
        QAndroidJniObject context =
                activity.callObjectMethod("getApplicationContext", "()Landroid/content/Context;");
        QAndroidJniObject cameraManager =
                context.callObjectMethod("getSystemService",
                                         "(Ljava/lang/String;)Ljava/lang/Object;",
                                         service.object<jstring>());

        QAndroidJniObject cameraIDArray = cameraManager.callObjectMethod("getCameraIdList",
                                                                         "()[Ljava/lang/String;");
        jobjectArray cameraIDList = cameraIDArray.object<jobjectArray>();

        QAndroidJniObject cameraType =
                QAndroidJniObject::getStaticObjectField("android/hardware/camera2/CameraCharacteristics",
                                                        "LENS_FACING",
                                                        "Landroid/hardware/camera2/CameraCharacteristics$Key;");

        QAndroidJniEnvironment environment;
        for (int i = 0; i < environment->GetArrayLength(cameraIDList); i++)
        {
            jstring index = static_cast<jstring>(environment->GetObjectArrayElement(cameraIDList, i));
            const char* id = environment->GetStringUTFChars(index, nullptr);
            QAndroidJniObject cameraID = QAndroidJniObject::fromString(id);

            QAndroidJniObject characteristics =
                    cameraManager.callObjectMethod("getCameraCharacteristics",
                                                   "(Ljava/lang/String;"
                                                   ")Landroid/hardware/camera2/CameraCharacteristics;",
                                                   cameraID.object<jstring>());

            QAndroidJniObject currentPositionCamera =
                    characteristics.callObjectMethod("get",
                                                     "(Landroid/hardware/camera2/CameraCharacteristics$Key;"
                                                     ")Ljava/lang/Object;",
                                                     cameraType.object<jobject>());

            if (currentPositionCamera.toString() == scBackCamera)
            {
                QAndroidJniObject sensorOrientation =
                        QAndroidJniObject::getStaticObjectField("android/hardware/camera2/CameraCharacteristics",
                                                                "SENSOR_ORIENTATION",
                                                                "Landroid/hardware/camera2/CameraCharacteristics$Key;");
                QAndroidJniObject orientation =
                        characteristics.callObjectMethod("get",
                                                         "(Landroid/hardware/camera2/CameraCharacteristics$Key;"
                                                         ")Ljava/lang/Object;",
                                                         sensorOrientation.object<jobject>());
                result = orientation.toString().toInt();
            }
            environment->ReleaseStringUTFChars(index, id);
            environment->DeleteLocalRef(index);
        }
    }
#endif
    return result;
}

#ifdef Q_OS_ANDROID
void GraftClientTools::permissionCallback(const QtAndroid::PermissionResultMap &result, GraftClientTools::Buttons button) const
{
    if (result.value(scCameraPermission) == QtAndroid::PermissionResult::Denied)
    {
        emit cameraPermissionGranted(!QtAndroid::shouldShowRequestPermissionRationale(scCameraPermission)
                                     ? CameraPermissionStatus::Denied : CameraPermissionStatus::Unknown, button);
    }
    else
    {
        emit cameraPermissionGranted(CameraPermissionStatus::Granted, button);
    }
}
#endif
