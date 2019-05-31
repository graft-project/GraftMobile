#ifndef IOSTOOLS_H
#define IOSTOOLS_H

#include "abstractdevicetools.h"

class IOSTools : public AbstractDeviceTools
{
    Q_OBJECT
public:
    explicit IOSTools(QObject *parent = nullptr);
    ~IOSTools() override;

    bool isSpecialTypeDevice() const override;

    double bottomNavigationBarHeight() const override;
    double statusBarHeight() const override;

    void checkAppVersion() const override;

private:
    mutable bool mIsIphoneXTypeDevice;
    mutable double mBottomNavigationBarHeight;
    mutable double mStatusBarHeight;
};

#endif // IOSTOOLS_H
