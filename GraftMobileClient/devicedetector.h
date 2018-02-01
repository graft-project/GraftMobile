#ifndef DEVICEDETECTOR_H
#define DEVICEDETECTOR_H

#include <QObject>

class QQmlEngine;

class DeviceDetector : public QObject
{
    Q_OBJECT
public:
    enum DeviceModels {
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
    Q_ENUM(DeviceModels)

    enum PlatformFlags {
        IOS = 0x01,
        Android = 0x02,
        Windows = 0x04,
        Linux = 0x08,
        MacOS = 0x10,
        Mobile = IOS | Android,
        Desktop = Windows | Linux | MacOS,
        Any = Mobile | Desktop
    };
    Q_DECLARE_FLAGS(Platforms, PlatformFlags)
    Q_FLAG(Platforms)

    DeviceDetector(QObject *parent = nullptr);

    void registerTypes(QQmlEngine *engine);

    Q_INVOKABLE static int detectDevice();
    Q_INVOKABLE static bool isPlatform(Platforms platform);
    Q_INVOKABLE static bool isDesktop();
    Q_INVOKABLE static bool isMobile();
};
Q_DECLARE_OPERATORS_FOR_FLAGS(DeviceDetector::Platforms)

#endif // DEVICEDETECTOR_H
