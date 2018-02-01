#include "devicedetector.h"

#include <QGuiApplication>
#include <QQmlContext>
#include <QQmlEngine>
#include <QScreen>

static const QMap<int, QSize> scDevicesMap
{
    {DeviceDetector::IPhoneNormal,  QSize{750,  1334}},
    {DeviceDetector::IPhonePlus,    QSize{1242, 2208}},
    {DeviceDetector::IPhoneSE,      QSize{640,  1136}},
    {DeviceDetector::IPhoneX,       QSize{1125, 2436}},
    {DeviceDetector::IPadPro12_9,   QSize{2048, 2732}},
    {DeviceDetector::IPadPro10_5,   QSize{1668, 2224}},
    {DeviceDetector::IPad,          QSize{1536, 2048}}
};

DeviceDetector::DeviceDetector(QObject *parent) : QObject(parent)
{
}

void DeviceDetector::registerTypes(QQmlEngine *engine)
{
    engine->rootContext()->setContextProperty(QStringLiteral("Device"), this);
    qmlRegisterType<DeviceDetector>("com.device.detector", 1, 0, "DeviceDetector");
    qmlRegisterType<DeviceDetector>("com.device.platforms", 1, 0, "PlatformsDetector");
}

int DeviceDetector::detectDevice()
{
    int currentDevice = -1;
    QScreen *currentScreen = QGuiApplication::primaryScreen();
    if (currentScreen)
    {
        int devicePixelRatio = currentScreen->devicePixelRatio();
        auto currentOrientation = currentScreen->primaryOrientation();
        if (currentOrientation == Qt::PortraitOrientation || currentOrientation == Qt::InvertedPortraitOrientation)
        {
            currentDevice = scDevicesMap.key(currentScreen->size() * devicePixelRatio, currentDevice);
        }
        else if (currentOrientation == Qt::LandscapeOrientation || currentOrientation == Qt::InvertedLandscapeOrientation)
        {
            currentDevice = scDevicesMap.key(currentScreen->size().transposed() * devicePixelRatio,
                                             currentDevice);
        }
    }
    return currentDevice;
}

bool DeviceDetector::isPlatform(DeviceDetector::Platforms platform)
{
    DeviceDetector::Platforms currentPlatform;
#ifdef Q_OS_WIN
    currentPlatform = DeviceDetector::Windows;
#endif
#ifdef Q_OS_MAC
    currentPlatform = DeviceDetector::MacOS;
#endif
#ifdef Q_OS_LINUX
    currentPlatform = DeviceDetector::Linux;
#endif
#ifdef Q_OS_IOS
    currentPlatform = DeviceDetector::IOS;
#endif
#ifdef Q_OS_ANDROID
    currentPlatform = DeviceDetector::Android;
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
