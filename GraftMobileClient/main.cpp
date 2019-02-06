#include <QQmlApplicationEngine>
#include <QNetworkProxyFactory>
#include <QApplication>
#include <QQmlContext>
#include <QQuickView>
#include <QFileInfo>
#include <QDir>

#include "core/selectedproductproxymodel.h"
#include "core/quickexchangemodel.h"
#include "core/graftwalletclient.h"
#include "core/graftposclient.h"
#include "core/currencymodel.h"
#include "core/accountmodel.h"
#include "core/productmodel.h"
#include "core/cardmodel.h"
#include "core/defines.h"

#include "devicedetector.h"
#include "designfactory.h"
#include "QZXing.h"

#if !defined(POS_BUILD) && !defined(WALLET_BUILD)
static_assert(false, "You didn't add additional argument POS_BUILD or WALLET_BUILD for qmake in \'Build Settings->Build Steps\'");
#endif

#if !defined(Q_OS_ANDROID) && !defined(Q_OS_IOS)
#include <QSplashScreen>
#include <QPixmap>
#endif

#ifdef Q_OS_ANDROID
#include <QtAndroid>
#endif

#ifdef WALLET_BUILD
#if defined(Q_OS_IOS)
#include "ios/wallet/ioscamerapermission.h"
#endif
#endif

#ifdef POS_BUILD
#if defined(Q_OS_ANDROID) || defined (Q_OS_IOS)
#include "imagepicker.h"
#endif
#endif

int main(int argc, char *argv[])
{
    // TODO: QTBUG-61153. QML cache doesn't get updated when adding Q_ENUM keys
    // For more details see https://bugreports.qt.io/browse/QTBUG-61153
    qputenv("QML_DISABLE_DISK_CACHE", "1");

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QNetworkProxyFactory::setUseSystemConfiguration(true);
    QApplication app(argc, argv);
#if !defined(Q_OS_ANDROID) && !defined(Q_OS_IOS)
    QPixmap background(":/imgs/SplashScreen.png");
    QSplashScreen *splashScreen = new QSplashScreen(background.scaled(386, 715));
    splashScreen->move(766, 148);
    splashScreen->show();
#endif
    QQmlApplicationEngine engine;
    DesignFactory factory;
    factory.registrate(engine.rootContext());
    QZXing::registerQMLTypes();
    DeviceDetector detector;
    detector.registerTypes(&engine);
#ifdef POS_BUILD
    app.setWindowIcon(QIcon(":/imgs/icon-pos.png"));

    qmlRegisterType<ProductModel>("org.graft.models", 1, 0, "ProductModelEnum");

    GraftPOSClient client;
    client.registerTypes(&engine);

    CurrencyModel model;
    model.add(QStringLiteral("GRFT"), QStringLiteral("GRAFT"));
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
    app.setWindowIcon(QIcon(":/imgs/icon-wallet.png"));

    GraftWalletClient client;
    client.registerTypes(&engine);

    CardModel cardModel;
    engine.rootContext()->setContextProperty(QStringLiteral("CardModel"), &cardModel);

    engine.rootContext()->setContextProperty(QStringLiteral("PaymentProductModel"),
                                             client.paymentProductModel());
    engine.rootContext()->setContextProperty(QStringLiteral("GraftClient"), &client);

#if defined(Q_OS_IOS)
    IOSCameraPermission cameraPermission;
    engine.rootContext()->setContextProperty(QStringLiteral("IOSCameraPermission"), &cameraPermission);
#endif

    engine.load(QUrl(QLatin1String("qrc:/wallet/main.qml")));
#endif
    if (engine.rootObjects().isEmpty())
        return -1;

#ifdef Q_OS_ANDROID
    QtAndroid::hideSplashScreen();
#endif

#if !defined(Q_OS_ANDROID) && !defined(Q_OS_IOS)
    splashScreen->deleteLater();
#endif
    return app.exec();
}
