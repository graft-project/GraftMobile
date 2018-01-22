#include "devicedetector.h"

#include <QGuiApplication>
#include <QQmlContext>
#include <QQmlEngine>
#include <QScreen>

static const QMap<int, QSize> scDevicesMap
{
    {DeviceDetector::iPhoneNormal,  QSize{750,  1334}},
    {DeviceDetector::iPhonePlus,    QSize{1242, 2208}},
    {DeviceDetector::iPhoneSE,      QSize{640,  1136}},
    {DeviceDetector::iPhoneX,       QSize{1125, 2436}},
    {DeviceDetector::iPadPro12_9,   QSize{2048, 2732}},
    {DeviceDetector::iPadPro10_5,   QSize{1668, 2224}},
    {DeviceDetector::iPad,          QSize{1536, 2048}}
};

DeviceDetector::DeviceDetector(QObject *parent) : QObject(parent)
{
}

void DeviceDetector::registerTypes(QQmlEngine *engine)
{
    engine->rootContext()->setContextProperty(QStringLiteral("Device"), this);
    qmlRegisterType<DeviceDetector>("com.device.detector", 1, 0, "DeviceDetector");
}

int DeviceDetector::detectDevice()
{
    int currentDevice = -1;
    QScreen *currentScreen = QGuiApplication::primaryScreen();
    if (currentScreen)
    {
        int devicePixelRatio = currentScreen->devicePixelRatio();
        if (currentScreen->primaryOrientation() == Qt::PortraitOrientation ||
            currentScreen->primaryOrientation() == Qt::InvertedPortraitOrientation)
        {
            currentDevice = scDevicesMap.key(currentScreen->size() * devicePixelRatio, currentDevice);
        }
        else if (currentScreen->primaryOrientation() == Qt::LandscapeOrientation ||
                 currentScreen->primaryOrientation() == Qt::InvertedLandscapeOrientation)
        {
            currentDevice = scDevicesMap.key(currentScreen->size().transposed() * devicePixelRatio,
                                             currentDevice);
        }
    }
    return currentDevice;
}
