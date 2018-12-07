QT += androidextras

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
    $$PWD/pos/res/layout/splashscreen.xml
}

contains(DEFINES, WALLET_BUILD) {
ANDROID_PACKAGE_SOURCE_DIR = $$PWD/wallet
DISTFILES += \
    $$PWD/wallet/AndroidManifest.xml \
    $$PWD/wallet/gradle/wrapper/gradle-wrapper.jar \
    $$PWD/wallet/gradlew \
    $$PWD/wallet/res/values/libs.xml \
    $$PWD/wallet/res/values/styles.xml \
    $$PWD/wallet/build.gradle \
    $$PWD/wallet/gradle/wrapper/gradle-wrapper.properties \
    $$PWD/wallet/gradlew.bat
}

SSL_PWD = $$PWD/3rdparty/openssl

equals(ANDROID_TARGET_ARCH, armeabi-v7a) {
    ANDROID_EXTRA_LIBS += $$SSL_PWD/armeabi-v7a/libcrypto.so
    ANDROID_EXTRA_LIBS += $$SSL_PWD/armeabi-v7a/libssl.so
}

equals(ANDROID_TARGET_ARCH, x86)  {
    ANDROID_EXTRA_LIBS += $$SSL_PWD/x86/libcrypto.so
    ANDROID_EXTRA_LIBS += $$SSL_PWD/x86/libssl.so
}
