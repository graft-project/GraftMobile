win32 {

contains(QMAKE_TARGET.arch, x86) {
    COMPILER_VERSION = msvc2015_x86
} else {
    COMPILER_VERSION = msvc2017_x64
}

LIB_PWD = $$PWD/windows/$$COMPILER_VERSION

CONFIG(debug, debug|release) {
BUILD_TARGET = debug
}

CONFIG(release, debug|release) {
BUILD_TARGET = release
}

LIBS += -L$$LIB_PWD/$$BUILD_TARGET -llibeay32 -lssleay32
}

# Qt since 5.12.5 uses openssl 1.1
# see https://github.com/KDAB/android_openssl for details
android {

LIB_PWD = $$PWD/android
equals(ANDROID_TARGET_ARCH, armeabi-v7a) {
    COMPILER_VERSION = armeabi-v7a
}

equals(ANDROID_TARGET_ARCH, arm64-v8a)  {
    COMPILER_VERSION = arm64-v8a
}

equals(ANDROID_TARGET_ARCH, x86)  {
    COMPILER_VERSION = x86
}

ANDROID_EXTRA_LIBS += $$LIB_PWD/$$COMPILER_VERSION/libcrypto_1_1.so
ANDROID_EXTRA_LIBS += $$LIB_PWD/$$COMPILER_VERSION/libssl_1_1.so

LIBS += -L$$LIB_PWD/$$COMPILER_VERSION -lcrypto_1_1 -lssl_1_1
}
