#include <QQmlApplicationEngine>
#include <QGuiApplication>
#include <QQmlContext>
#include <QQuickView>
#include <QFileInfo>
#include <QDir>

#include "core/cardmodel.h"
#include "core/accountmodel.h"
#include "core/productmodel.h"
#include "core/currencymodel.h"
#include "core/graftposclient.h"
#include "core/graftwalletclient.h"
#include "core/quickexchangemodel.h"
#include "core/selectedproductproxymodel.h"
#include "core/defines.h"
#include "designfactory.h"

#ifdef POS_BUILD
#ifdef Q_OS_ANDROID || Q_OS_IOS
#include "imagepicker.h"
#endif
#endif

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
    model.add(QStringLiteral("USD"), QStringLiteral("USD"));
    model.add(QStringLiteral("GRAFT"), QStringLiteral("GRAFT"));
    engine.rootContext()->setContextProperty(QStringLiteral("CurrencyModel"), &model);

    QString imageDataLocation = callImageDataPath();
    if(!QFileInfo(imageDataLocation).exists())
    {
        QDir().mkpath(imageDataLocation);
    }

#ifdef Q_OS_ANDROID || Q_OS_IOS
    ImagePicker picker(imageDataLocation);
    engine.rootContext()->setContextProperty(QStringLiteral("ImagePicker"), &picker);
#endif

    engine.rootContext()->setContextProperty(QStringLiteral("SelectedProductModel"),
                                             client.selectedProductModel());
    engine.rootContext()->setContextProperty(QStringLiteral("ProductModel"), client.productModel());
    engine.rootContext()->setContextProperty(QStringLiteral("CurrencyModel"), &model);
    engine.rootContext()->setContextProperty(QStringLiteral("QuickExchangeModel"),
                                             client.quickExchangeModel());
    engine.rootContext()->setContextProperty(QStringLiteral("GraftClient"), &client);
    engine.load(QUrl(QLatin1String("qrc:/pos/main.qml")));
#endif
#ifdef WALLET_BUILD
    QZXing::registerQMLTypes();
    GraftWalletClient client;

    CurrencyModel coinModel;
    coinModel.add(QStringLiteral("BITCONNECT COIN"), QStringLiteral("qrc:/imgs/coins/bcc.png"));
    coinModel.add(QStringLiteral("BITCOIN"), QStringLiteral("qrc:/imgs/coins/bitcoin.png"));
    coinModel.add(QStringLiteral("DASH"), QStringLiteral("qrc:/imgs/coins/dash.png"));
    coinModel.add(QStringLiteral("ETHER"), QStringLiteral("qrc:/imgs/coins/ether.png"));
    coinModel.add(QStringLiteral("LITECOIN"), QStringLiteral("qrc:/imgs/coins/litecoin.png"));
    coinModel.add(QStringLiteral("MONERO"), QStringLiteral("qrc:/imgs/coins/monero.png"));
    coinModel.add(QStringLiteral("NEW ECONOMY MOVEMENT"), QStringLiteral("qrc:/imgs/coins/nem.png"));
    coinModel.add(QStringLiteral("NEO"), QStringLiteral("qrc:/imgs/coins/neo.png"));
    coinModel.add(QStringLiteral("RIPPLE"), QStringLiteral("qrc:/imgs/coins/ripple.png"));
    engine.rootContext()->setContextProperty(QStringLiteral("CoinModel"), &coinModel);

    AccountModel accountModel;
    engine.rootContext()->setContextProperty(QStringLiteral("AccountModel"), &accountModel);

    CardModel cardModel;
    engine.rootContext()->setContextProperty(QStringLiteral("QuickExchangeModel"),
                                             client.quickExchangeModel());
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
