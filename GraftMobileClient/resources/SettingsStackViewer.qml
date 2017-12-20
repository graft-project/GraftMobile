import QtQuick 2.9
import QtQuick.Controls 2.2

StackView {
    id: stack

    property var menuLoader
    property var pushScreen: ({})
    property string appType: "pos"

    focus: true
    initialItem: openSettingsScreen()
    Keys.onReleased: {
        if (!busy && (event.key === Qt.Key_Back || event.key === Qt.Key_Escape)) {
            if (currentItem.isMenuActive === false) {
                pop()
                event.accepted = true
            }
        }
    }

    function settingsTransitions() {
        var transitionsMap = pushScreen
        transitionsMap["openSettingsScreen"] = openSettingsScreen
        transitionsMap["openMnemonicViewScreen"] = openMnemonicViewScreen
        transitionsMap["openMainScreen"] = openMainScreen
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

    function openMnemonicViewScreen(isAccountExist) {
        stack.push("qrc:/MnemomicViewScreen.qml", {"pushScreen": settingsTransitions(),
                   "screenState": isAccountExist})
    }

    function openMainScreen() {
        mainLayout.currentIndex = 1
    }

    function goBack() {
        pop()
    }
}
