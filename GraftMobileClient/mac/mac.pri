LIBS += -framework Foundation \
        -framework Carbon \
        -framework IOKit

contains(DEFINES, POS_BUILD) {
BUILD_DIR = $$PWD/pos
}
contains(DEFINES, WALLET_BUILD) {
BUILD_DIR = $$PWD/wallet
}

QMAKE_INFO_PLIST = $${BUILD_DIR}/Info.plist

ICON = $${BUILD_DIR}/icon.icns
