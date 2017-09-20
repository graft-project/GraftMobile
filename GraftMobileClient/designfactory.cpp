#include "designfactory.h"

#include <QQmlContext>
#include <QQmlEngine>

DesignFactory::DesignFactory(QObject *parent) : QObject(parent)
{
    mColors.insert(ForegroundAndroid, QStringLiteral("#34435b"));
    mColors.insert(ForegroundIos, QStringLiteral("#394558"));
    mColors.insert(CircleBackground, QStringLiteral("#4fb67a"));
    mColors.insert(Menu, QStringLiteral("#283c4a"));
    mColors.insert(Highlighting, QStringLiteral("#ecf4ef"));
    mColors.insert(ItemHighlighting, QStringLiteral("#fedbb4"));
    mColors.insert(MainText, QStringLiteral("#616161"));
    mColors.insert(DarkText, QStringLiteral("#383737"));
    mColors.insert(LightText, QStringLiteral("#ffffff"));
    mColors.insert(CartLabel, QStringLiteral("#fe4200"));
    mColors.insert(AllocateLine, QStringLiteral("#cccccc"));
}

QString DesignFactory::color(DesignFactory::ColorTypes type) const
{
    return mColors.value(type);
}

void DesignFactory::registrate(QQmlContext *context)
{
    qmlRegisterType<DesignFactory>("com.graft.design", 1, 0, "DesignFactory");
    context->setContextProperty(QStringLiteral("ColorFactory"), this);
}
