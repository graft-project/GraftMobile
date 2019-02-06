INCLUDEPATH += $$PWD/include

android {
equals(ANDROID_TARGET_ARCH, armeabi-v7a) {
    CONFIG(debug, debug|release) {
        LIBS += -L$$PWD/android/armv7/debug/ -lImagePickerLibrary
        ANDROID_EXTRA_LIBS += $$PWD/android/armv7/debug/libImagePickerLibrary.so
    }
    else:CONFIG(release, debug|release) {
        LIBS += -L$$PWD/android/armv7/release/ -lImagePickerLibrary
        ANDROID_EXTRA_LIBS += $$PWD/android/armv7/release/libImagePickerLibrary.so
    }
}

equals(ANDROID_TARGET_ARCH, x86) {
    CONFIG(debug, debug|release) {
        LIBS += -L$$PWD/android/x86/debug/ -lImagePickerLibrary
        ANDROID_EXTRA_LIBS += $$PWD/android/x86/debug/libImagePickerLibrary.so
    }
    else:CONFIG(release, debug|release) {
        LIBS += -L$$PWD/android/x86/release/ -lImagePickerLibrary
        ANDROID_EXTRA_LIBS += $$PWD/android/x86/release/libImagePickerLibrary.so
    }
}
}

ios {
    LIBS += -framework AVFoundation

    CONFIG(debug, debug|release) {
        LIBS += $$PWD/ios/debug/libImagePickerLibrary.a
    }
    CONFIG(release, debug|release) {
        LIBS += $$PWD/ios/release/libImagePickerLibrary.a
    }
}
