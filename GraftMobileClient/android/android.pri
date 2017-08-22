QT += androidextras

if (contains(DEFINES, POS_BUILD)) {
TARGET = GraftPointOfSale
ANDROID_PACKAGE_SOURCE_DIR = $$PWD/pos
DISTFILES += \
    $$PWD/pos/AndroidManifest.xml \
    $$PWD/pos/src/com/splashscreen/SplashActivity.java \
    android/pos/gradle/wrapper/gradle-wrapper.jar \
    android/pos/gradlew \
    android/pos/res/values/libs.xml \
    android/pos/res/values/styles.xml \
    android/pos/build.gradle \
    android/pos/gradle/wrapper/gradle-wrapper.properties \
    android/pos/gradlew.bat
}

if (contains(DEFINES, WALLET_BUILD)) {
TARGET = GraftWallet
ANDROID_PACKAGE_SOURCE_DIR = $$PWD/wallet
DISTFILES += \
    $$PWD/wallet/AndroidManifest.xml \
    $$PWD/wallet/src/com/splashscreen/SplashActivity.java \
    android/wallet/gradle/wrapper/gradle-wrapper.jar \
    android/wallet/gradlew \
    android/wallet/res/values/libs.xml \
    android/wallet/res/values/styles.xml \
    android/wallet/build.gradle \
    android/wallet/gradle/wrapper/gradle-wrapper.properties \
    android/wallet/gradlew.bat
}
