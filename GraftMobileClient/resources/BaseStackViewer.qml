import QtQuick 2.9
import QtQuick.Controls 2.2
import com.device.platform 1.0

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
        if (Detector.isPlatform(Platform.Windows)) {
            currentItem.nextItemInFocusChain().forceActiveFocus(Qt.TabFocusReason)
            currentItem.replyOnFocusReason()
        }
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
