INCLUDEPATH += $$PWD/include \
               $$PWD/include/epee \
               $$PWD/include/external/easylogging++

## TODO: there're mix of copy-pasted epee/libcncrypto header files, sort them out to a separate directories (too keep the same directory structure as in GraftNetwork project)

android {
## TODO

} else {
    linux {
        # XXX: order matters (epee first), wont link otherwise (undefined reference to easylogging)
	LIBS += -L$$PWD/../libwallet/wallet/linux -lepee -leasylogging 
	# XXX: order matters (utils first), wont link otherwise (undefined reference to cn_clow_hash, chacha8)
	LIBS += -L$$PWD/lib/linux -lutils -lcncrypto 
	LIBS += -lboost_filesystem \
		-lboost_thread
    }
}

ios {
    LIBS += -L$$PWD/../libwallet/wallet/ios -leasylogging -lepee
    LIBS += -L$$PWD/lib/ios -lcncrypto
} else {
    mac {
	LIBS += -L$$PWD/../libwallet/wallet/mac -leasylogging -lepee
	LIBS += -L$$PWD/lib/mac -lcncrypto
    }
}
