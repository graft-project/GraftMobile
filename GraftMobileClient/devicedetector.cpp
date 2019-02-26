#include "devicedetector.h"

#include <QGuiApplication>
#include <QQmlContext>
#include <QQmlEngine>
#include <QScreen>

#ifdef Q_OS_IOS
#include "ios/iostools.h"
#endif

DeviceDetector::DeviceDetector(QObject *parent)
    : QObject(parent)
    ,mDeviceType{nullptr}
{
#ifdef Q_OS_IOS
    mDeviceType = new IOSTools(this);
#endif
}

void DeviceDetector::registerTypes(QQmlEngine *engine)
{
    engine->rootContext()->setContextProperty(QStringLiteral("Detector"), this);
    qmlRegisterType<DeviceDetector>("com.device.platform", 1, 0, "Platform");
}

bool DeviceDetector::isPlatform(DeviceDetector::Platforms platform)
{
    DeviceDetector::Platforms currentPlatform;
#if defined(Q_OS_IOS)
    currentPlatform = DeviceDetector::IOS;
#elif defined(Q_OS_ANDROID)
    currentPlatform = DeviceDetector::Android;
#elif defined(Q_OS_WIN)
    currentPlatform = DeviceDetector::Windows;
#elif defined(Q_OS_MAC)
    currentPlatform = DeviceDetector::MacOS;
#elif defined(Q_OS_LINUX)
    currentPlatform = DeviceDetector::Linux;
#endif
    return currentPlatform & platform;
}

bool DeviceDetector::isDesktop()
{
    return isPlatform(DeviceDetector::Desktop);
}

bool DeviceDetector::isMobile()
{
    return isPlatform(DeviceDetector::Mobile);
}

bool DeviceDetector::isSpecialTypeDevice()
{
    return mDeviceType ? mDeviceType->isSpecialTypeDevice() : false;
}

double DeviceDetector::bottomNavigationBarHeight()
{
    return mDeviceType ? mDeviceType->bottomNavigationBarHeight() : 0.0;
}

double DeviceDetector::statusBarHeight()
{
    return mDeviceType ? mDeviceType->statusBarHeight() : 0.0;
}
