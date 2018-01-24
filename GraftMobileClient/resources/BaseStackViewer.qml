import QtQuick 2.9
import QtQuick.Controls 2.2

StackView {
    id: stack

    property var menuLoader
    property var pushScreen: ({})
    property bool isActive: false

    focus: true
    onCurrentItemChanged: {
        if (isActive && menuLoader && menuLoader.status === Loader.Ready) {
            menuLoader.item.interactive = currentItem.isMenuActive
        }
    }

    function goBack() {
        pop()
    }

    function backButtonHandler() {
        var back = false
        if (!busy && currentItem.isMenuActive === false) {
                goBack()
                currentItem.isMenuActive = true
                back = true
            }
        return back
    }
}
