#include <QQmlApplicationEngine>
#include <QGuiApplication>
#include <QQmlContext>
#include <QQuickView>

#include "core/cardmodel.h"
#include "core/productmodel.h"
#include "core/currencymodel.h"
#include "core/graftposclient.h"
#include "core/graftwalletclient.h"
#include "core/selectedproductproxymodel.h"
#include "designfactory.h"

#ifdef WALLET_BUILD
#include <QZXing.h>
#endif

#ifdef Q_OS_ANDROID
#include <QtAndroid>
#endif

int main(int argc, char *argv[])
{
    // TODO: QTBUG-61153. QML cache doesn't get updated when adding Q_ENUM keys
    // For more details see https://bugreports.qt.io/browse/QTBUG-61153
    qputenv("QML_DISABLE_DISK_CACHE", "1");

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    DesignFactory factory;
    factory.registrate(engine.rootContext());
#ifdef POS_BUILD
    qmlRegisterType<ProductModel>("org.graft.models", 1, 0, "ProductModelEnum");

    GraftPOSClient client;
    client.registerImageProvider(&engine);

    CurrencyModel model;
    model.add("USD", "USD");
    model.add("GRAFT", "GRAFT");

    engine.rootContext()->setContextProperty(QStringLiteral("SelectedProductModel"),
                                             client.selectedProductModel());
    engine.rootContext()->setContextProperty(QStringLiteral("ProductModel"), client.productModel());
    engine.rootContext()->setContextProperty(QStringLiteral("CurrencyModel"), &model);
    engine.rootContext()->setContextProperty(QStringLiteral("GraftClient"), &client);
    engine.load(QUrl(QLatin1String("qrc:/pos/main.qml")));
#endif
#ifdef WALLET_BUILD
    QZXing::registerQMLTypes();

    GraftWalletClient client;
    CardModel cardModel;
    engine.rootContext()->setContextProperty(QStringLiteral("CardModel"), &cardModel);
    engine.rootContext()->setContextProperty(QStringLiteral("PaymentProductModel"),
                                             client.paymentProductModel());
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
