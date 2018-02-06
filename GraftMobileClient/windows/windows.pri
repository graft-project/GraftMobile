contains(DEFINES, POS_BUILD) {
RESOURCE_DIR = $$PWD/pos
}

contains(DEFINES, WALLET_BUILD) {
RESOURCE_DIR = $$PWD/wallet
}

RC_FILE = $$RESOURCE_DIR/resource.rc
