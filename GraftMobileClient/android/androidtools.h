#ifndef ANDROIDTOOLS_H
#define ANDROIDTOOLS_H

#include "abstractdevicetools.h"

class AndroidTools : public AbstractDeviceTools
{
    Q_OBJECT
public:
    explicit AndroidTools(QObject *parent = nullptr);
    ~AndroidTools() override;

    bool isSpecialTypeDevice() const override;
    double bottomNavigationBarHeight() const override;
    double statusBarHeight() const override;

    void checkAppVersion() const override;

private slots:
    void processCheckAppVersion() const;

private:
    static void getPackageName();
};

#endif // ANDROIDTOOLS_H
