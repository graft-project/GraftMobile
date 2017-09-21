QT += qml quick network

CONFIG += c++11

ios {
include(ios/ios.pri)
}

android {
include(android/android.pri)
}

contains(DEFINES, POS_BUILD) {
TARGET = GraftPointOfSale
}

contains(DEFINES, WALLET_BUILD) {
include(QZXing.pri)

TARGET = GraftWallet
}

SOURCES += main.cpp \
    core/graftposclient.cpp \
    core/graftwalletclient.cpp \
    core/api/graftgenericapi.cpp \
    core/api/graftposapi.cpp \
    core/api/graftwalletapi.cpp \
    core/productmodel.cpp \
    core/productitem.cpp \
    core/productmodelserializator.cpp \
    core/patrickqrcodeencoder.cpp \
    core/graftbaseclient.cpp \
    core/barcodeimageprovider.cpp \
    core/carditem.cpp \
    core/cardmodel.cpp \
    core/keygenerator.cpp \
    core/selectedproductproxymodel.cpp \
    designfactory.cpp

HEADERS += \
    core/config.h \
    core/graftposclient.h \
    core/graftwalletclient.h \
    core/api/graftgenericapi.h \
    core/api/graftposapi.h \
    core/api/graftwalletapi.h \
    core/productitem.h \
    core/productmodel.h \
    core/productmodelserializator.h \
    core/patrickqrcodeencoder.h \
    core/graftbaseclient.h \
    core/barcodeimageprovider.h \
    core/carditem.h \
    core/cardmodel.h \
    core/keygenerator.h \
    core/selectedproductproxymodel.h \
    designfactory.h

include(resources/resources.pri)

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
