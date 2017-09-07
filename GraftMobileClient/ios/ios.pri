contains(DEFINES, POS_BUILD) {
    app_splash_screen.files = $$PWD/pos/SplashScreen.xib \
                              $$PWD/pos/graft_pos_logo.png
    QMAKE_BUNDLE_DATA += app_splash_screen
    QMAKE_INFO_PLIST = $$PWD/pos/Info_pos.plist
    QMAKE_ASSET_CATALOGS += $$PWD/Images.xcassets
}

contains(DEFINES, WALLET_BUILD) {
    app_splash_screen.files = $$files($$PWD/wallet/SplashScreen/*)
    QMAKE_BUNDLE_DATA += app_splash_screen
    QMAKE_INFO_PLIST = $$PWD/wallet/Info_wallet.plist
    QMAKE_ASSET_CATALOGS += $$PWD/Images.xcassets
}
