#ifndef DESIGNFACTORY_H
#define DESIGNFACTORY_H

#include <QObject>
#include <QMap>

class QQmlContext;

class DesignFactory : public QObject
{
    Q_OBJECT
public:
    explicit DesignFactory(QObject *parent = nullptr);

    enum ColorTypes {
        Foreground,
        IosNavigationBar,
        CircleBackground,
        Highlighting,
        ItemHighlighting,
        AndroidMainText,
        IosMainText,
        AndroidItemText,
        IosItemText,
        LightText,
        CartLabel,
        AllocateLine,
        AndroidStatusBar
    };
    Q_ENUM(ColorTypes)

    Q_INVOKABLE QString color(ColorTypes type) const;
    void registrate(QQmlContext *context);

private:
    void init();
    QMap<int, QString> mColors;
};

#endif // DESIGNFACTORY_H
