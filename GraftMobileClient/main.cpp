#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QZXing.h>
#include <QQuickView>
#include <QQmlContext>
#include "core/productmodel.h"
#include "core/qrcodeview.h"
#include "core/graftbaseclient.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QZXing::registerQMLTypes();
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
#ifdef POS_BUILD
    qmlRegisterType<QRCodeView>("com.pos.graft", 1, 0, "QRCodeView");
    qmlRegisterType<GraftBaseClient>("com.pos.graft", 1, 0, "GraftBaseClient");

    ProductModel productModel;
    engine.rootContext()->setContextProperty(QStringLiteral("productModel"), &productModel);
    engine.load(QUrl(QLatin1String("qrc:/pos/main.qml")));
#endif
#ifdef WALLET_BUILD
    engine.load(QUrl(QLatin1String("qrc:/wallet/main.qml")));
#endif
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
