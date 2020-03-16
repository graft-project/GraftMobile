#
# Latest RTA API (REST) & Handlers. 
# it's confusing but latest API versioned as "v2", please don't mess with v2 directory, it's not the same
# Files in v2 directory re-using libwallet to implement appropriate wallet operations. 
# These files is the same as v1 but using new (REST) POS/Wallet calls implemented on supernode
#

contains(DEFINES, POS_BUILD) {

SOURCES += \
    $$PWD/graftposapiv3.cpp \
    $$PWD/graftposhandlerv3.cpp

HEADERS += \
    $$PWD/graftposapiv3.h \
    $$PWD/graftposhandlerv3.h
}

contains(DEFINES, WALLET_BUILD) {
SOURCES += \
    $$PWD/graftwalletapiv3.cpp \
    $$PWD/graftwallethandlerv3.cpp

HEADERS += \
    $$PWD/graftwalletapiv3.h \
    $$PWD/graftwallethandlerv3.h
}

SOURCES += \
    $$PWD/graftgenericapiv3.cpp \
    $$PWD/privatepaymentdetails.cpp

HEADERS += \
    $$PWD/graftgenericapiv3.h  \
    $$PWD/privatepaymentdetails.h




