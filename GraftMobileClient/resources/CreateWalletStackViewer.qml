import QtQuick 2.9
import QtQuick.Controls 2.2

BaseStackViewer {
    id: stack
    initialItem: selectNetworkScreen
    clearStackViewer: backToSelectNetworkScreen

    SelectNetworkScreen {
        id: selectNetworkScreen
        pushScreen: createWalletsTransitions()
    }

    function createWalletsTransitions() {
        var transitionsMap = pushScreen
        transitionsMap["openRestoreWalletScreen"] = openRestoreWalletScreen
        transitionsMap["openMnemonicViewScreen"] = openMnemonicViewScreen
        transitionsMap["openCreateWalletScreen"] = openCreateWalletScreen
        transitionsMap["backToSelectNetworkScreen"] = backToSelectNetworkScreen
        transitionsMap["serviceSettingsScreen"] = serviceSettingsScreen
        transitionsMap["openBaseScreen"] = openBaseScreen
        transitionsMap["goBack"] = goBack
        return transitionsMap
    }

    function openRestoreWalletScreen() {
        stack.push("qrc:/RestoreScreen.qml", {"pushScreen": createWalletsTransitions()})
    }

    function openMnemonicViewScreen(isAccountExists) {
        stack.push("qrc:/MnemomicViewScreen.qml", {"pushScreen": createWalletsTransitions(),
                   "screenState": isAccountExists})
    }

    function openCreateWalletScreen() {
        stack.push("qrc:/CreateWalletScreen.qml", {"pushScreen": createWalletsTransitions()})
    }

    function backToSelectNetworkScreen() {
        stack.pop(selectNetworkScreen)
    }

    function serviceSettingsScreen() {
        stack.push("qrc:/ServiceSettingsScreen.qml", {"pushScreen": createWalletsTransitions()})
    }

    function openBaseScreen() {
        pushScreen.openMainScreen()
    }
}
