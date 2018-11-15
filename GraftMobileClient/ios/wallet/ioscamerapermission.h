#ifndef IOSCAMERAPERMISSION_H
#define IOSCAMERAPERMISSION_H

#include <QObject>

class IOSCameraPermission : public QObject
{
    Q_OBJECT
public:
    explicit IOSCameraPermission(QObject *parent = nullptr);

    Q_INVOKABLE bool hasPermission();
    Q_INVOKABLE void stopTimer();

signals:
    void hasCameraPermission(bool result);

protected:
    void timerEvent(QTimerEvent *event) override;

private:
    int mTimer;
};

#endif // IOSCAMERAPERMISSION_H
