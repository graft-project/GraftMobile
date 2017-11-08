RESOURCES += $$PWD/general_qml.qrc

ios {
RESOURCES += $$PWD/ios_qml.qrc
}

android {
RESOURCES += $$PWD/android_qml.qrc
}

win32|macx|unix {
contains(DEFINES, RES_IOS) {
RESOURCES += $$PWD/ios_qml.qrc
} else {
RESOURCES += $$PWD/android_qml.qrc
}
}
