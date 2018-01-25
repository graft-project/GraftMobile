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

    DeviceDetector(QObject *parent = nullptr);

    void registerTypes(QQmlEngine *engine);
    Q_INVOKABLE static int detectDevice();
};

#endif // DEVICEDETECTOR_H
