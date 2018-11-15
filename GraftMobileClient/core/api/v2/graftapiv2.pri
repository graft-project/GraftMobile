contains(DEFINES, POS_BUILD) {

SOURCES += \
    $$PWD/graftposapiv2.cpp \
    $$PWD/graftposhandlerv2.cpp

HEADERS += \
    $$PWD/graftposapiv2.h \
    $$PWD/graftposhandlerv2.h
}

contains(DEFINES, WALLET_BUILD) {
SOURCES += \
    $$PWD/graftwalletapiv2.cpp \
    $$PWD/graftwallethandlerv2.cpp

HEADERS += \
    $$PWD/graftwalletapiv2.h \
    $$PWD/graftwallethandlerv2.h
}

SOURCES += \
    $$PWD/graftgenericapiv2.cpp \
    $$PWD/graftwallet.cpp \
    $$PWD/graftwalletlistener.cpp

HEADERS += \
    $$PWD/graftgenericapiv2.h \
    $$PWD/graftwallet.h \
    $$PWD/graftwalletlistener.h
