#include <QQmlApplicationEngine>
#include <QGuiApplication>
#include <QQmlContext>
#include <QQuickView>
#include <QFileInfo>
#include <QZXing.h>
#include <QDir>

#include "core/cardmodel.h"
#include "core/accountmodel.h"
#include "core/productmodel.h"
#include "core/currencymodel.h"
#include "core/graftposclient.h"
#include "core/graftwalletclient.h"
#include "core/quickexchangemodel.h"
#include "core/selectedproductproxymodel.h"
#include "core/devicedetector.h"
#include "core/defines.h"
#include "designfactory.h"

#ifdef POS_BUILD
#if defined(Q_OS_ANDROID) || defined (Q_OS_IOS)
#include "imagepicker.h"
#endif
#endif

#ifdef Q_OS_IOS
#include <QFont>
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
    QZXing::registerQMLTypes();
    DeviceDetector detector;
    detector.registerTypes(&engine);
#ifdef POS_BUILD
    qmlRegisterType<ProductModel>("org.graft.models", 1, 0, "ProductModelEnum");

    GraftPOSClient client;
    client.registerTypes(&engine);

    CurrencyModel model;
    model.add(QStringLiteral("USD"), QStringLiteral("USD"));
    model.add(QStringLiteral("GRAFT"), QStringLiteral("GRAFT"));
    engine.rootContext()->setContextProperty(QStringLiteral("CurrencyModel"), &model);

    QString imageDataLocation = callImageDataPath();
    if(!QFileInfo(imageDataLocation).exists())
    {
        QDir().mkpath(imageDataLocation);
    }

#if defined(Q_OS_ANDROID) || defined (Q_OS_IOS)
    ImagePicker picker(imageDataLocation);
    engine.rootContext()->setContextProperty(QStringLiteral("ImagePicker"), &picker);
#endif

    engine.rootContext()->setContextProperty(QStringLiteral("SelectedProductModel"),
                                             client.selectedProductModel());
    engine.rootContext()->setContextProperty(QStringLiteral("ProductModel"), client.productModel());
    engine.rootContext()->setContextProperty(QStringLiteral("GraftClient"), &client);
    engine.load(QUrl(QLatin1String("qrc:/pos/main.qml")));
#endif
#ifdef WALLET_BUILD
    GraftWalletClient client;
    client.registerTypes(&engine);

    CardModel cardModel;
    engine.rootContext()->setContextProperty(QStringLiteral("CardModel"), &cardModel);

    engine.rootContext()->setContextProperty(QStringLiteral("PaymentProductModel"),
                                             client.paymentProductModel());
    engine.rootContext()->setContextProperty(QStringLiteral("GraftClient"), &client);
    engine.load(QUrl(QLatin1String("qrc:/wallet/main.qml")));
#endif
    if (engine.rootObjects().isEmpty())
        return -1;

#ifdef Q_OS_IOS
    app.setFont(QFont ("Arial", 15));
#endif

#ifdef Q_OS_ANDROID
    QtAndroid::hideSplashScreen();
#endif
    return app.exec();
}
