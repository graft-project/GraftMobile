#include "designfactory.h"

#include <QQmlContext>
#include <QQmlEngine>

DesignFactory::DesignFactory(QObject *parent) : QObject(parent)
{
    mColors.insert(CircleBackground, QStringLiteral("#4fb67a"));
    mColors.insert(MainText, QStringLiteral("#757575"));
    mColors.insert(Foreground, QStringLiteral("#425665"));
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


