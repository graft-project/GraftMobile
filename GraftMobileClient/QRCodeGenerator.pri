#Name of repository: QR-Code-generator
#Author: Nayuki
#Link to original repository: https://github.com/nayuki/QR-Code-generator

QT += svg

INCLUDEPATH += $$PWD/qrcodegenerator/cpp/

HEADERS += \
    core/qrcodegenerator.h \
    $$PWD/qrcodegenerator/cpp/BitBuffer.hpp \
    $$PWD/qrcodegenerator/cpp/QrCode.hpp \
    $$PWD/qrcodegenerator/cpp/QrSegment.hpp

SOURCES += \
    core/qrcodegenerator.cpp \
    $$PWD/qrcodegenerator/cpp/BitBuffer.cpp \
    $$PWD/qrcodegenerator/cpp/QrCode.cpp \
    $$PWD/qrcodegenerator/cpp/QrSegment.cpp
