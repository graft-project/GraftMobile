DISTFILES += \
    android/wallet/AndroidManifest.xml \
    android/pos/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

if (contains(DEFINES, POS_BUILD)) {
ANDROID_PACKAGE_SOURCE_DIR = $$PWD/pos
DISTFILES += $$PWD/pos/AndroidManifest.xml
}

if (contains(DEFINES, WALLET_BUILD)) {
ANDROID_PACKAGE_SOURCE_DIR = $$PWD/wallet
DISTFILES += $$PWD/wallet/AndroidManifest.xml
}
