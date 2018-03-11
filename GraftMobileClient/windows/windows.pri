contains(DEFINES, POS_BUILD) {
RESOURCES += $$PWD/pos.qrc
RESOURCE_DIR = $$PWD/pos

DISTFILES += \
    $$RESOURCE_DIR/header.bmp \
    $$RESOURCE_DIR/welcome.bmp \
    $$RESOURCE_DIR/icon.ico \
    $$RESOURCE_DIR/install.nsi \
    $$RESOURCE_DIR/resource.rc
}

contains(DEFINES, WALLET_BUILD) {
RESOURCES += $$PWD/wallet.qrc
RESOURCE_DIR = $$PWD/wallet

DISTFILES += \
    $$RESOURCE_DIR/license.rtf \
    $$RESOURCE_DIR/header.bmp \
    $$RESOURCE_DIR/welcome.bmp \
    $$RESOURCE_DIR/icon.ico \
    $$RESOURCE_DIR/install.nsi \
    $$RESOURCE_DIR/resource.rc
}

RC_FILE = $$RESOURCE_DIR/resource.rc

CONFIG(release, debug|release) {
BUILD_DIR = release

contains(QMAKE_TARGET.arch, x86) {
    COMPILER_VERSION = msvc2015_x86
} else {
    COMPILER_VERSION = msvc2017_x64
}

OPENSSL_DIR = $$PWD/../3rdparty/openssl/$$COMPILER_VERSION/$$BUILD_DIR/*.dll
OPENSSL_DIR ~= s,/,\\,g

EXE_DIR = $${OUT_PWD}/$$DESTDIR
EXE_DIR ~= s,/,\\,g

RES_DIR = $${RESOURCE_DIR}/*
RES_DIR ~= s,/,\\,g

ESCAPE_COMMAND = $$escape_expand(\\n\\t)

openssl_target = $$quote(cmd /c $(COPY_DIR) $${OPENSSL_DIR} $${EXE_DIR}) $${ESCAPE_COMMAND}
nsis_target = $$quote(cmd /c $(COPY_DIR) $${RES_DIR} $${EXE_DIR}) $${ESCAPE_COMMAND}
QMAKE_POST_LINK += $${openssl_target} $${nsis_target}

NSIS_PATH = "C:\Program Files (x86)\NSIS\makensis.exe"
INSTALL_SCRIPT = $${EXE_DIR}/install.nsi

QT_DEPLOY = $$QMAKE_QMAKE
QT_DEPLOY ~= s,qmake.exe,windeployqt.exe,g
QT_DEPLOY ~= s,/,\\,g

QML_DIR = $$QMAKE_QMAKE
QML_DIR ~= s,bin/qmake.exe,qml,g
QML_DIR ~= s,/,\\,g

EXE_FILE = $${OUT_PWD}/$${DESTDIR}/$${TARGET}.exe
EXE_FILE ~= s,/,\\,g

QMAKE_POST_LINK += $${QT_DEPLOY} -qmldir $${QML_DIR} $$EXE_FILE $${ESCAPE_COMMAND}
QMAKE_POST_LINK += $${NSIS_PATH} $${INSTALL_SCRIPT} $${ESCAPE_COMMAND}
}
