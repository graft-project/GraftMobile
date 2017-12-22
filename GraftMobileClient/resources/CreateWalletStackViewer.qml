import QtQuick 2.9
import QtQuick.Controls 2.2

StackView {
    id: stack

    property var menuLoader
    property var pushScreen: ({})

    Component.onCompleted: {
        menuLoader.active = false
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
        pushScreen: createWalletsTransitions()
    }

    function createWalletsTransitions() {
        var transitionsMap = pushScreen
        transitionsMap["openRestoreWalletScreen"] = openRestoreWalletScreen
        transitionsMap["openMnemonicViewScreen"] = openMnemonicViewScreen
        transitionsMap["openMainScreen"] = openMainScreen
        transitionsMap["goBack"] = goBack
        return transitionsMap
    }

    function openRestoreWalletScreen() {
        stack.push("qrc:/RestoreScreen.qml", {"pushScreen": createWalletsTransitions()})
    }

    function openMnemonicViewScreen(isAccountExist) {
        stack.push("qrc:/MnemomicViewScreen.qml", {"pushScreen": createWalletsTransitions(),
                   "screenState": isAccountExist})
    }

    function openMainScreen() {
        mainLayout.currentIndex = 1
    }

    function goBack() {
        pop()
    }
}
