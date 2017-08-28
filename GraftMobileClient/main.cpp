#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QQmlContext>

#include "core/productmodel.h"
#include "core/graftposclient.h"
#include "core/graftwalletclient.h"
#include "core/selectedproductproxymodel.h"

#ifdef WALLET_BUILD
#include <QZXing.h>
#endif

#ifdef Q_OS_ANDROID
#include <QtAndroid>
#endif

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
#ifdef POS_BUILD
    GraftPOSClient client;
    client.registerImageProvider(&engine);

    ProductModel productModel;
    SelectedProductProxyModel selectedProductModel;
    selectedProductModel.setSourceModel(&productModel);
    engine.rootContext()->setContextProperty(QStringLiteral("SelectedProductModel"), &selectedProductModel);
    engine.rootContext()->setContextProperty(QStringLiteral("ProductModel"), &productModel);
    engine.rootContext()->setContextProperty(QStringLiteral("GraftClient"), &client);
    engine.load(QUrl(QLatin1String("qrc:/pos/main.qml")));
#endif
#ifdef WALLET_BUILD
    QZXing::registerQMLTypes();

    GraftWalletClient client;
    engine.rootContext()->setContextProperty(QStringLiteral("GraftClient"), &client);
    engine.load(QUrl(QLatin1String("qrc:/wallet/main.qml")));
#endif
    if (engine.rootObjects().isEmpty())
        return -1;

#ifdef Q_OS_ANDROID
    QtAndroid::hideSplashScreen();
#endif
    return app.exec();
}
