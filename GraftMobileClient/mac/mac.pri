LIBS += -framework Foundation \
        -framework Carbon \
        -framework IOKit

contains(DEFINES, POS_BUILD) {
BUILD_DIR = $$PWD/pos

DISTFILES += \
    $$BUILD_DIR/Info.plist \
    $$BUILD_DIR/icon.icns
}
contains(DEFINES, WALLET_BUILD) {
BUILD_DIR = $$PWD/wallet

DISTFILES += \
    $$BUILD_DIR/Info.plist \
    $$BUILD_DIR/icon.icns
}


QMAKE_INFO_PLIST = $${BUILD_DIR}/Info.plist

ICON = $${BUILD_DIR}/icon.icns

CONFIG(release, debug|release) {

ESCAPE_COMMAND = $$escape_expand(\\n\\t)

QT_DEPLOY = $$QMAKE_QMAKE
QT_DEPLOY ~= s,qmake,macdeployqt,g

QML_DIR = $$QMAKE_QMAKE
QML_DIR ~= s,bin/qmake,qml,g

APP_FILE = $${OUT_PWD}/$${DESTDIR}/$${TARGET}.app

QMAKE_POST_LINK += $${QT_DEPLOY} $$APP_FILE -qmldir=$${QML_DIR} -dmg $${ESCAPE_COMMAND}
}

