import QtQuick 2.9
import QtQuick.Controls 2.2

BaseStackViewer {
    id: stack
    initialItem: createWalletScreen

    Component.onCompleted: {
        menuLoader.active = false
    }

    CreateWalletScreen {
        id: createWalletScreen
        pushScreen: createWalletsTransitions()
    }

    function createWalletsTransitions() {
        var transitionsMap = pushScreen
        transitionsMap["openRestoreWalletScreen"] = openRestoreWalletScreen
        transitionsMap["openMnemonicViewScreen"] = openMnemonicViewScreen
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
}
