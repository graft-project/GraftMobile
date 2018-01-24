import QtQuick 2.9
import QtQuick.Controls 2.2

BaseStackViewer {
    id: stack

    property string appType: "pos"

    initialItem: openSettingsScreen()

    function settingsTransitions() {
        var transitionsMap = pushScreen
        transitionsMap["openSettingsScreen"] = openSettingsScreen
        transitionsMap["openMnemonicViewScreen"] = openMnemonicViewScreen
        transitionsMap["goBack"] = goBack
        return transitionsMap
    }

    function openSettingsScreen() {
        if (appType === "pos") {
            stack.push("qrc:/pos/SettingsScreen.qml", {"pushScreen": settingsTransitions()})
        } else {
            stack.push("qrc:/wallet/SettingsScreen.qml", {"pushScreen": settingsTransitions()})
        }
    }

    function openMnemonicViewScreen(isAccountExists) {
        stack.push("qrc:/MnemomicViewScreen.qml", {"pushScreen": settingsTransitions(),
                   "screenState": isAccountExists})
    }
}
