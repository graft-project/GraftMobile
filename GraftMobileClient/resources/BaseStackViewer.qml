import QtQuick 2.9
import QtQuick.Controls 2.2

StackView {
    id: stack

    property var menuLoader
    property var pushScreen: ({})
    property bool isActive: false
    property var clearStackViewer: ({})

    signal networkReplyError()

    focus: isActive
    onCurrentItemChanged: {
        if (isActive && menuLoader && menuLoader.status === Loader.Ready) {
            menuLoader.item.interactive = currentItem.isMenuActive && currentItem.isMenuVisible
        }
        // TODO: (Fixed in - 5.11.0 Alpha) QTBUG-51321. StackView should clear focus when a new item is pushed. For more details see:
        // https://bugreports.qt.io/browse/QTBUG-51321?jql=component%20%3D%20%22Quick%3A%20Controls%202%22%20AND%20text%20~%20%22Tab%22
        currentItem.nextItemInFocusChain().forceActiveFocus(Qt.TabFocusReason)
    }

    onNetworkReplyError: currentItem.networkReplyError()

    function goBack() {
        pop()
    }

    function backButtonHandler() {
        var back = false
        if (!busy && currentItem.isMenuActive === false) {
            if (currentItem.specialBackMode === null) {
                pop()
            } else {
                currentItem.specialBackMode()
            }
            back = true
        }
        return back
    }

    function enableScreen() {
        currentItem.enableScreen()
    }
}
