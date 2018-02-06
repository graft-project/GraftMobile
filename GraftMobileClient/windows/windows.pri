contains(DEFINES, POS_BUILD) {
RESOURCE_DIR = $$PWD/pos
}

contains(DEFINES, WALLET_BUILD) {
RESOURCE_DIR = $$PWD/wallet
}

RC_FILE = $$RESOURCE_DIR/resource.rc

CONFIG(release, debug|release) {
BUILD_DIR = release

OPENSSL_DIR = $$PWD/../3rdparty/openssl/msvc2017/$$BUILD_DIR/*.dll
OPENSSL_DIR ~= s,/,\\,g

EXE_DIR = $${OUT_PWD}/$$DESTDIR
EXE_DIR ~= s,/,\\,g

ESCAPE_COMMAND = $$escape_expand(\\n\\t)

openssl_target = $$quote(cmd /c $(COPY_DIR) $${OPENSSL_DIR} $${EXE_DIR}) $${ESCAPE_COMMAND}
QMAKE_POST_LINK += $${openssl_target}

QT_DEPLOY = $$QMAKE_QMAKE
QT_DEPLOY ~= s,qmake.exe,windeployqt.exe,g
QT_DEPLOY ~= s,/,\\,g

QML_DIR = $$QMAKE_QMAKE
QML_DIR ~= s,bin/qmake.exe,qml,g
QML_DIR ~= s,/,\\,g

EXE_FILE = $${OUT_PWD}/$${DESTDIR}/$${TARGET}.exe
EXE_FILE ~= s,/,\\,g

QMAKE_POST_LINK += $${QT_DEPLOY} -qmldir $${QML_DIR} $$EXE_FILE $${ESCAPE_COMMAND}
}
