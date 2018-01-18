import QtQuick 2.9
import QtQuick.Controls 2.2
import "components"

StackView {
    id: stack

    property var menuLoader
    property var pushScreen: ({})
    property bool isActive: false
    property bool closeApp: false

    Connections {
        target: currentItem
        onAnimationCompleted: closeApp = false
    }

    focus: true
    Keys.onReleased: {
        if (!busy && (event.key === Qt.Key_Back || event.key === Qt.Key_Escape)) {
            if (currentItem.isMenuActive === false) {
                pop()
                event.accepted = true
            } else {
                if (closeApp) {
                    event.accepted = false
                } else {
                    currentItem.closeLabelVisible = 1.0
                    currentItem.animationTimer.start()
                    event.accepted = true
                }
                closeApp = !closeApp
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
