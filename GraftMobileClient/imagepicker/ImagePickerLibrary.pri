INCLUDEPATH += $$PWD/include

android {
equals(ANDROID_TARGET_ARCH, armeabi-v7a) {
    LIBS += -L$$PWD/android/armv7/ -lImagePickerLibrary
    CONFIG(debug, debug|release) {
        ANDROID_EXTRA_LIBS += $$PWD/android/armv7/libImagePickerLibrary.so
    }
    else:CONFIG(release, debug|release) {
        ANDROID_EXTRA_LIBS += $$PWD/android/armv7/libImagePickerLibraryr.so
    }
}

equals(ANDROID_TARGET_ARCH, x86) {
    LIBS += -L$$PWD/android/x86/ -lImagePickerLibrary
    CONFIG(debug, debug|release) {
        ANDROID_EXTRA_LIBS += $$PWD/android/x86/libImagePickerLibrary.so
    }
    else:CONFIG(release, debug|release) {
        ANDROID_EXTRA_LIBS += $$PWD/android/x86/libImagePickerLibraryr.so
    }
}
}

ios {
    CONFIG(debug, debug|release) {
        LIBS += $$PWD/ios/debug/libImagePickerLibrary.a
    }
    CONFIG(release, debug|release) {
        LIBS += $$PWD/ios/release/libImagePickerLibrary.a
    }
}
