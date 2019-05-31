#include "abstractdevicetools.h"
#include "devicedetector.h"

#include <QGuiApplication>
#include <QQmlContext>
#include <QQmlEngine>
#include <QScreen>

#ifdef Q_OS_IOS
#include "ios/iostools.h"
#endif

#ifdef Q_OS_ANDROID
#include "android/androidtools.h"
#endif

DeviceDetector::DeviceDetector(QObject *parent)
    : QObject(parent)
    ,mNetworkManager{nullptr}
    ,mDeviceType{nullptr}
{
#ifdef Q_OS_IOS
    mDeviceType = new IOSTools(this);
#elif defined(Q_OS_ANDROID)
    mDeviceType = new AndroidTools(this);
#endif

    if (mDeviceType)
    {
        connect(mDeviceType, &AbstractDeviceTools::updateNeeded,
                this, &DeviceDetector::updateNeeded);
    }
}

void DeviceDetector::registerTypes(QQmlEngine *engine)
{
    engine->rootContext()->setContextProperty(QStringLiteral("Detector"), this);
    qmlRegisterType<DeviceDetector>("com.device.platform", 1, 0, "Platform");
}

void DeviceDetector::setNetworkManager(QNetworkAccessManager *networkManager)
{
    if (networkManager && mNetworkManager != networkManager)
    {
        mNetworkManager = networkManager;
        if (mDeviceType)
        {
            mDeviceType->setNetworkManager(mNetworkManager);
        }
    }
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
#elif defined(Q_OS_MACOS)
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

void DeviceDetector::checkAppVersion()
{
    if (mDeviceType)
    {
        mDeviceType->checkAppVersion();
    }
}
