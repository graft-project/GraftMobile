contains(DEFINES, POS_BUILD) {
    app_splash_screen.files = $$files($$PWD/pos/SplashScreen/*)
    QMAKE_BUNDLE_DATA += app_splash_screen
    QMAKE_INFO_PLIST = $$PWD/pos/Info_pos.plist
    QMAKE_ASSET_CATALOGS += $$PWD/pos/Images.xcassets

    DISTFILES += \
        $$PWD/pos/Info_pos.plist
}

contains(DEFINES, WALLET_BUILD) {
    app_splash_screen.files = $$files($$PWD/wallet/SplashScreen/*)
    QMAKE_BUNDLE_DATA += app_splash_screen
    QMAKE_INFO_PLIST = $$PWD/wallet/Info_wallet.plist
    QMAKE_ASSET_CATALOGS += $$PWD/wallet/Images.xcassets

    DISTFILES += \
        $$PWD/wallet/Info_wallet.plist
}

