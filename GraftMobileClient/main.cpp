#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QZXing.h>
#include <QQuickView>
#include <QQmlContext>

#include "core/productmodel.h"
#include "core/graftwalletclient.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QZXing::registerQMLTypes();
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
#ifdef POS_BUILD
    ProductModel productModel;
    engine.rootContext()->setContextProperty(QStringLiteral("productModel"), &productModel);
    engine.load(QUrl(QLatin1String("qrc:/pos/main.qml")));
#endif
#ifdef WALLET_BUILD
    GraftWalletClient walletClient;
    engine.rootContext()->setContextProperty("walletClient", &walletClient);
    engine.load(QUrl(QLatin1String("qrc:/wallet/main.qml")));
#endif
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
