QT += androidextras

contains(DEFINES, POS_BUILD) {
ANDROID_PACKAGE_SOURCE_DIR = $$PWD/pos
DISTFILES += \
    $$PWD/pos/AndroidManifest.xml \
    $$PWD/pos/src/com/splashscreen/SplashActivity.java \
    $$PWD/pos/gradle/wrapper/gradle-wrapper.jar \
    $$PWD/pos/gradlew \
    $$PWD/pos/res/values/libs.xml \
    $$PWD/pos/res/values/styles.xml \
    $$PWD/pos/build.gradle \
    $$PWD/pos/gradle/wrapper/gradle-wrapper.properties \
    $$PWD/pos/gradlew.bat
}

contains(DEFINES, WALLET_BUILD) {
ANDROID_PACKAGE_SOURCE_DIR = $$PWD/wallet
DISTFILES += \
    $$PWD/wallet/AndroidManifest.xml \
    $$PWD/wallet/src/com/splashscreen/SplashActivity.java \
    $$PWD/wallet/gradle/wrapper/gradle-wrapper.jar \
    $$PWD/wallet/gradlew \
    $$PWD/wallet/res/values/libs.xml \
    $$PWD/wallet/res/values/styles.xml \
    $$PWD/wallet/build.gradle \
    $$PWD/wallet/gradle/wrapper/gradle-wrapper.properties \
    $$PWD/wallet/gradlew.bat
}
