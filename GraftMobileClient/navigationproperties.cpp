#include "navigationproperties.h"

#include <QQmlContext>

NavigationProperties::NavigationProperties(QObject *parent)
    : QObject(parent)
    ,mExplicitFirstComponent(nullptr)
    ,mExplicitLastComponent(nullptr)
    ,mImplicitFirstComponent(nullptr)
    ,mImplicitLastComponent(nullptr)
{
}

void NavigationProperties::registerTypes()
{
    qmlRegisterType<NavigationProperties>("org.navigation.attached.properties", 1, 0, "Navigation");
}

NavigationProperties *NavigationProperties::qmlAttachedProperties(QObject *item)
{
    return new NavigationProperties(item);
}

QObject *NavigationProperties::explicitFirstComponent() const
{
    return mExplicitFirstComponent;
}

void NavigationProperties::setExplicitFirstComponent(QObject *component)
{
    if (mExplicitFirstComponent != component)
    {
        mExplicitFirstComponent = component;
        emit explicitFirstChanged();
    }
}

QObject *NavigationProperties::explicitLastComponent() const
{
    return mExplicitLastComponent;
}

void NavigationProperties::setExplicitLastComponent(QObject *component)
{
    if (mExplicitLastComponent != component)
    {
        mExplicitLastComponent = component;
        emit explicitLastChanged();
    }
}

QObject *NavigationProperties::implicitFirstComponent() const
{
    return mImplicitFirstComponent;
}

void NavigationProperties::setImplicitFirstComponent(QObject *component)
{
    if (mImplicitFirstComponent != component)
    {
        mImplicitFirstComponent = component;
        emit implicitFirstChanged();
    }
}

QObject *NavigationProperties::implicitLastComponent() const
{
    return mImplicitLastComponent;
}

void NavigationProperties::setImplicitLastComponent(QObject *component)
{
    if (mImplicitLastComponent != component)
    {
        mImplicitLastComponent = component;
        emit implicitLastChanged();
    }
}
