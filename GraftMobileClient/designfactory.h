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
        ForegroundAndroid = 0,
        ForegroundIos,
        CircleBackground,
        Menu,
        Highlighting,
        ItemHighlighting,
        MainText,
        DarkText,
        LightText,
        CartLabel,
        AllocateLine
    };
    Q_ENUMS(ColorTypes)

    Q_INVOKABLE QString color(ColorTypes type) const;
    void registrate(QQmlContext *context);

private:
    QMap<int, QString> mColors;
};

#endif // DESIGNFACTORY_H
