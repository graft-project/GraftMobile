if (contains(DEFINES, POS_BUILD)) {
ANDROID_PACKAGE_SOURCE_DIR = $$PWD/pos
OTHER_FILES = $$PWD/pos/AndroidManifest.xml
}

if (contains(DEFINES, WALLET_BUILD)) {
ANDROID_PACKAGE_SOURCE_DIR = $$PWD/wallet
OTHER_FILES = $$PWD/wallet/AndroidManifest.xml
}
