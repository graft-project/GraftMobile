ios {
contains(DEFINES, POS_BUILD) {
    app_splash_screen.files = $$PWD/pos/SplashScreen.xib \
                              $$PWD/pos/graft_pos_logo.png
    QMAKE_BUNDLE_DATA += app_splash_screen
    QMAKE_INFO_PLIST = ios/pos/Info_pos.plist
}

contains(DEFINES, WALLET_BUILD) {
    app_splash_screen.files = $$PWD/wallet/SplashScreen.xib \
                              $$PWD/wallet/graft_wallet_logo.png
    QMAKE_BUNDLE_DATA += app_splash_screen
    QMAKE_INFO_PLIST = ios/wallet/Info_wallet.plist
}
}
