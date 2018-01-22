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
    int devicePixelRatio = QGuiApplication::primaryScreen()->devicePixelRatio();
    int currentDevice = -1;
    if (QGuiApplication::primaryScreen()->primaryOrientation() == Qt::PortraitOrientation ||
        QGuiApplication::primaryScreen()->primaryOrientation() == Qt::InvertedPortraitOrientation)
    {
        currentDevice = scDevicesMap.key(QGuiApplication::primaryScreen()->size() * devicePixelRatio
                                         , currentDevice);
    }
    else if (QGuiApplication::primaryScreen()->primaryOrientation() == Qt::LandscapeOrientation ||
               QGuiApplication::primaryScreen()->primaryOrientation() == Qt::InvertedLandscapeOrientation)
    {
        currentDevice = scDevicesMap.key(QGuiApplication::primaryScreen()->size().transposed() *
                                         devicePixelRatio, currentDevice);
    }
    return currentDevice;
}
