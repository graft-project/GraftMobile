#ifndef DEVICEDETECTOR_H
#define DEVICEDETECTOR_H

#include <QQmlEngine>
#include <QObject>

class DeviceDetector : public QObject
{
    Q_OBJECT
public:
    enum DeviceModels {
        iPhoneNormal = 0,
        iPhonePlus,
        iPhoneSE,
        iPhoneX,
        iPadPro12_9,
        iPadPro10_5,
        iPad,
        iPhone6S = iPhoneNormal,
        iPhone7 = iPhoneNormal,
        iPhone8 = iPhoneNormal,
        iPhone6SPlus = iPhonePlus,
        iPhone7Plus = iPhonePlus,
        iPhone8Plus = iPhonePlus,
        iPad9_7 = iPad,
        iPad7_9 = iPad
    };
    Q_ENUM(DeviceModels)

    DeviceDetector(QObject *parent = nullptr);

    void registerTypes(QQmlEngine *engine);
    Q_INVOKABLE static int detectDevice();
};

#endif // DEVICEDETECTOR_H
