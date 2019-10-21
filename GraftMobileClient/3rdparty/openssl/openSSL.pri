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

ANDROID_EXTRA_LIBS += $$LIB_PWD/$$COMPILER_VERSION/libcrypto.so
ANDROID_EXTRA_LIBS += $$LIB_PWD/$$COMPILER_VERSION/libssl.so

LIBS += -L$$LIB_PWD/$$COMPILER_VERSION -lcrypto -lssl
}
