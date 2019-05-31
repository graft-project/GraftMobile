#ifndef GRAFTCLIENTTOOLS_H
#define GRAFTCLIENTTOOLS_H

#include <QObject>

// TODO: QTBUG-74076. The application is crash or will hang when request permission, after the
// native Android keyboard. For more details see https://bugreports.qt.io/browse/QTBUG-74076.
// Also, the need to get a camera orientation.
#ifdef Q_OS_ANDROID
#include <QtAndroid>
#endif

class GraftClientTools : public QObject
{
    Q_OBJECT
public:
    enum BalanceTypes {
        LockedBalance = 0,
        UnlockedBalance,
        LocalBalance
    };
    Q_ENUM(BalanceTypes)

    enum NetworkConfiguration
    {
        Mainnet = 0,
        PublicTestnet,
        PublicExperimentalTestnet
    };
    Q_ENUM(NetworkConfiguration)

    enum NetworkType
    {
        Http = 0,
        Https,
        None
    };
    Q_ENUM(NetworkType)

    enum CameraPermissionStatus {
        Granted = 0,
        Denied,
        Unknown
    };
    Q_ENUM(CameraPermissionStatus)

    enum Buttons {
        Send = 0,
        Pay,
        Undefined
    };
    Q_ENUM(Buttons)

    explicit GraftClientTools(QObject *parent = nullptr);

    Q_INVOKABLE static bool isValidIp(const QString &ip);
    Q_INVOKABLE static bool isValidUrl(const QString &urlAddress);

    Q_INVOKABLE static QString wideSpacingSimplify(const QString &seed);

    Q_INVOKABLE static void copyToClipboard(const QString &data);

    Q_INVOKABLE static QString dotsRemove(const QString &message);

    Q_INVOKABLE static NetworkType networkType(const QString &text);

    // TODO: QTBUG-74076. The application is crash or will hang when request permission, after the
    // native Android keyboard. For more details see https://bugreports.qt.io/browse/QTBUG-74076
    Q_INVOKABLE void requestCameraPermission(GraftClientTools::Buttons button = GraftClientTools::Undefined) const;

    Q_INVOKABLE int cameraOrientation() const;

signals:
    void cameraPermissionGranted(int result, int button) const;

#ifdef Q_OS_ANDROID
private:
    void permissionCallback(const QtAndroid::PermissionResultMap &result, GraftClientTools::Buttons button) const;
#endif
};

#endif // GRAFTCLIENTTOOLS_H
