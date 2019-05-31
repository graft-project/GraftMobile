RESOURCES += $$PWD/general_qml.qrc
QTQUICK_COMPILER_SKIPPED_RESOURCES += $$PWD/general_qml.qrc

ios {
RESOURCES += $$PWD/ios_qml.qrc
}

android {
RESOURCES += $$PWD/android_qml.qrc
RESOURCES += $$PWD/fonts_qml.qrc
}

win32|macx|unix {
contains(DEFINES, RES_IOS) {
RESOURCES += $$PWD/ios_qml.qrc
contains(DEFINES, POS_BUILD) {
RESOURCES += $$PWD/desktop_pos.qrc
}
contains(DEFINES, WALLET_BUILD) {
RESOURCES += $$PWD/desktop_wallet.qrc
}
} else {
RESOURCES += $$PWD/android_qml.qrc
}
}
