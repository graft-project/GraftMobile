contains(DEFINES, POS_BUILD) {
    TARGET = GraftMobilePointOfSale

    app_splash_screen.files = $$files($$PWD/pos/SplashScreen/*)
    QMAKE_BUNDLE_DATA += app_splash_screen
    QMAKE_INFO_PLIST =
    QMAKE_ASSET_CATALOGS += $$PWD/pos/Images.xcassets

    DISTFILES +=
}

contains(DEFINES, WALLET_BUILD) {
    TARGET = GraftCryptoPayWallet

    app_splash_screen.files = $$files($$PWD/wallet/SplashScreen/*)
    QMAKE_BUNDLE_DATA += app_splash_screen
    QMAKE_INFO_PLIST =
    QMAKE_ASSET_CATALOGS += $$PWD/wallet/Images.xcassets

    DISTFILES +=
}

DISTFILES += \
    $$PWD/pos/Info.plist \
    $$PWD/wallet/Info.plist

