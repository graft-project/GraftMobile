QT += androidextras

HEADERS += \
    $$PWD/androidtools.h

SOURCES += \
    $$PWD/androidtools.cpp

contains(DEFINES, POS_BUILD) {
ANDROID_PACKAGE_SOURCE_DIR = $$PWD/pos
DISTFILES += \
    $$PWD/pos/AndroidManifest.xml \
    $$PWD/pos/gradlew \
    $$PWD/pos/gradlew.bat \
    $$PWD/pos/build.gradle \
    $$PWD/pos/gradle/wrapper/gradle-wrapper.jar \
    $$PWD/pos/gradle/wrapper/gradle-wrapper.properties \
    $$PWD/pos/res/values/libs.xml \
    $$PWD/pos/res/values/styles.xml \
    $$PWD/pos/res/mipmap-anydpi-v26/ic_launcher.xml \
    $$PWD/pos/res/mipmap-anydpi-v26/ic_launcher_round.xml \
    $$PWD/pos/res/drawable/splashscreen.xml \
    $$PWD/pos/res/layout/splashscreen.xml \
    $$PWD/pos/res/xml/provider_paths.xml
}

contains(DEFINES, WALLET_BUILD) {
ANDROID_PACKAGE_SOURCE_DIR = $$PWD/wallet
DISTFILES += \
    $$PWD/wallet/AndroidManifest.xml \
    $$PWD/wallet/gradlew \
    $$PWD/wallet/gradlew.bat \
    $$PWD/wallet/build.gradle \
    $$PWD/wallet/gradle/wrapper/gradle-wrapper.jar \
    $$PWD/wallet/gradle/wrapper/gradle-wrapper.properties \
    $$PWD/wallet/res/values/libs.xml \
    $$PWD/wallet/res/values/styles.xml \
    $$PWD/wallet/res/mipmap-anydpi-v26/ic_launcher.xml \
    $$PWD/wallet/res/mipmap-anydpi-v26/ic_launcher_round.xml \
    $$PWD/wallet/res/drawable/splashscreen.xml \
    $$PWD/wallet/res/layout/splashscreen.xml
}
