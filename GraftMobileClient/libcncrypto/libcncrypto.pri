INCLUDEPATH += $$PWD

## TODO: there're mix of copy-pasted epee/libcncrypto header files, sort them out to a separate directories?

android {
## TODO

} else {
    linux {
        # XXX: order matters (epee first), wont link otherwise (undefined reference to easylogging)
	LIBS += -L$$PWD/../libwallet/wallet/linux -lepee -leasylogging 
	LIBS += -L$$PWD/linux -lcncrypto
	LIBS += -lboost_filesystem \
		-lboost_thread
    }
}

ios {
    LIBS += -L$$PWD/../libwallet/wallet/ios -leasylogging -lepee
    LIBS += -L$$PWD/ios -lcncrypto
} else {
    mac {
	LIBS += -L$$PWD/../libwallet/wallet/mac -leasylogging -lepee
	LIBS += -L$$PWD/mac -lcncrypto
    }
}
