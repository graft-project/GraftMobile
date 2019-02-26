#ifndef ABSTRACTDEVICETOOLS_H
#define ABSTRACTDEVICETOOLS_H

#include <QObject>

class AbstractDeviceTools : public QObject
{
    Q_OBJECT
public:
    explicit AbstractDeviceTools(QObject *parent = nullptr);
    virtual ~AbstractDeviceTools();

    virtual bool isSpecialTypeDevice() const = 0;

    virtual double bottomNavigationBarHeight() const = 0;
    virtual double statusBarHeight() const = 0;
};

#endif // ABSTRACTDEVICETOOLS_H
