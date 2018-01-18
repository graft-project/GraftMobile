import QtQuick 2.9
import QtQuick.Controls 2.2

StackView {
    id: stack
    property var menuLoader
    property var pushScreen: ({})
    property bool isActive: false
    property bool allowClose: false

    Connections {
        target: currentItem
        onAnimationCompleted: allowClose = false
    }

    focus: true
    Keys.onReleased: {
        if (!busy && (event.key === Qt.Key_Back || event.key === Qt.Key_Escape)) {
            if (currentItem.isMenuActive === false) {
                pop()
                event.accepted = true
            } else {
                if (allowClose) {
                    event.accepted = false
                } else {
                    currentItem.showCloseLabel()
                    event.accepted = true
                }
                allowClose = !allowClose
            }
        }
    }

    onCurrentItemChanged: {
        if (isActive && menuLoader && menuLoader.status === Loader.Ready) {
            menuLoader.item.interactive = currentItem.isMenuActive
        }
    }

    function goBack() {
        pop()
    }
}
