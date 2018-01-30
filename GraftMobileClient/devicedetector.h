#ifndef DEVICEDETECTOR_H
#define DEVICEDETECTOR_H

#include <QObject>

class QQmlEngine;

class DeviceDetector : public QObject
{
    Q_OBJECT
    Q_ENUMS(iOSDeviceModels)
    Q_ENUMS(AndroidDeviceModels)

public:
    enum iOSDeviceModels {
        IPhoneNormal = 0,
        IPhonePlus,
        IPhoneSE,
        IPhoneX,
        IPadPro12_9,
        IPadPro10_5,
        IPad,
        IPhone6S = IPhoneNormal,
        IPhone7 = IPhoneNormal,
        IPhone8 = IPhoneNormal,
        IPhone6SPlus = IPhonePlus,
        IPhone7Plus = IPhonePlus,
        IPhone8Plus = IPhonePlus,
        IPad9_7 = IPad,
        IPad7_9 = IPad
    };
    Q_ENUM(iOSDeviceModels)

    enum AndroidDeviceModels {
        Oreo = 0,
        Nougat,
        Marshmallow,
        Lollipop,
        KitKat,
        JellyBean,
        IceCream,
        Sandwich
    };
    Q_ENUM(AndroidDeviceModels)

    enum PlatformFlags {
        iOS = 1 << iOSDeviceModels,
        Android = 1 << AndroidDeviceModels,
        Windows,
        Linux,
        MacOS,
        Mobile = iOS | Android,
        Desktop = Windows | Linux | MacOS,
        Any = Mobile | Desktop
    };
    Q_FLAG(PlatformFlags)
    Q_DECLARE_FLAGS(PlatformFlags, PlatformFlags)


    DeviceDetector(QObject *parent = nullptr);

    void registerTypes(QQmlEngine *engine);
    Q_INVOKABLE static int detectDevice();

    bool isDesktop();
    bool isMobile();
    bool isPlatform(PlatformFlags platform);
};

Q_DECLARE_OPERATORS_FOR_FLAGS(DeviceDetector::PlatformFlags)

#endif // DEVICEDETECTOR_H
