import QtQuick 2.9
import QtQuick.Controls 2.2

StackView {
    id: stack

    property var pushScreen: ({})

    Component.onCompleted: {
        menuLoader.actice = false
    }

    focus: true
    initialItem: createWalletScreen
    Keys.onReleased: {
        if (!busy && (event.key === Qt.Key_Back || event.key === Qt.Key_Escape)) {
            if (currentItem.isMenuActive === false) {
                pop()
                event.accepted = true
            }
        }
    }

    CreateWalletScreen {
        id: createWalletScreen
        pushScreen: walletsTransitions()
    }

    function createWalletsTransitions() {
        var transitionsMap = pushScreen
        transitionsMap["openCreateWalletScreen"] = openCreateWalletScreen

        transitionsMap["goBack"] = goBack
        return transitionsMap
    }

    function openCreateWalletScreen() {
        stack.push("qrc:/CreateWalletScreen.qml", {"pushScreen": createWalletsTransitions()})
    }

    function goBack() {
        pop()
    }
}
