#ifndef DEVICEDETECTOR_H
#define DEVICEDETECTOR_H

#include <QObject>

class AbstractDeviceTools;
class QQmlEngine;

class DeviceDetector : public QObject
{
    Q_OBJECT
public:
    enum PlatformFlags {
        IOS = 0x01,
        Android = 0x02,
        Windows = 0x04,
        MacOS = 0x08,
        Linux = 0x10,
        Mobile = IOS | Android,
        Desktop = Windows | MacOS | Linux,
        Any = Mobile | Desktop
    };
    Q_DECLARE_FLAGS(Platforms, PlatformFlags)
    Q_FLAG(Platforms)

    DeviceDetector(QObject *parent = nullptr);

    void registerTypes(QQmlEngine *engine);

    Q_INVOKABLE static bool isPlatform(Platforms platform);
    Q_INVOKABLE static bool isDesktop();
    Q_INVOKABLE static bool isMobile();

    Q_INVOKABLE bool isSpecialTypeDevice();

    Q_INVOKABLE double bottomNavigationBarHeight();
    Q_INVOKABLE double statusBarHeight();

private:
    AbstractDeviceTools *mDeviceType;
};
Q_DECLARE_OPERATORS_FOR_FLAGS(DeviceDetector::Platforms)

#endif // DEVICEDETECTOR_H
