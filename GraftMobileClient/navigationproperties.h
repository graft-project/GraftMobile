#ifndef NAVIGATIONPROPERTIES_H
#define NAVIGATIONPROPERTIES_H

#include <QQmlEngine>
#include <QObject>

class NavigationProperties : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QObject *explicitFirstComponent READ explicitFirstComponent
               WRITE setExplicitFirstComponent NOTIFY explicitFirstChanged)
    Q_PROPERTY(QObject *explicitLastComponent READ explicitLastComponent
               WRITE setExplicitLastComponent NOTIFY explicitLastChanged)
    Q_PROPERTY(QObject *implicitFirstComponent READ implicitFirstComponent
               WRITE setImplicitFirstComponent NOTIFY implicitFirstChanged)
    Q_PROPERTY(QObject *implicitLastComponent READ implicitLastComponent
               WRITE setImplicitLastComponent NOTIFY implicitLastChanged)

public:
    explicit NavigationProperties(QObject *parent = nullptr);
    static void registerTypes();

    static NavigationProperties *qmlAttachedProperties(QObject *item);

    QObject *explicitFirstComponent() const;
    void setExplicitFirstComponent(QObject *component);

    QObject *explicitLastComponent() const;
    void setExplicitLastComponent(QObject *component);

    QObject *implicitFirstComponent() const;
    void setImplicitFirstComponent(QObject *component);

    QObject *implicitLastComponent() const;
    void setImplicitLastComponent(QObject *component);

signals:
    void explicitFirstChanged();
    void explicitLastChanged();
    void implicitFirstChanged();
    void implicitLastChanged();

private:
    QObject *mExplicitFirstComponent;
    QObject *mExplicitLastComponent;
    QObject *mImplicitFirstComponent;
    QObject *mImplicitLastComponent;
};
QML_DECLARE_TYPEINFO(NavigationProperties, QML_HAS_ATTACHED_PROPERTIES)

#endif // NAVIGATIONPROPERTIES_H
