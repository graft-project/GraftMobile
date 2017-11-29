import QtQuick 2.9
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import org.graft 1.0
import "../"
import "../components"

GraftApplicationWindow {
    id: root
    title: qsTr("WALLET")

    Loader {
        id: drawerLoader
        onLoaded: {
            drawerLoader.item.pushScreen = menuTransitions()
            drawerLoader.item.balanceInGraft = GraftClient.balance(GraftClientTools.UnlockedBalance)
        }
    }

    footer: Loader {
        id: footerLoader
        onLoaded: footerLoader.item.pushScreen = menuTransitions()
    }

    Component.onCompleted: {
        if (Qt.platform.os === "ios") {
            footerLoader.source = "qrc:/wallet/GraftToolBar.qml"
        } else {
            drawerLoader.source = "qrc:/wallet/GraftMenu.qml"
        }
    }

    Connections {
        target: GraftClient

        onErrorReceived: {
            if (message !== "") {
                messageDialog.title = qsTr("Network Error")
                messageDialog.text = message
            } else {
                messageDialog.title = qsTr("Pay failed!")
                messageDialog.text = qsTr("Pay request failed.\nPlease try again.")
            }
            messageDialog.open()
        }
    }

    MessageDialog {
        id: messageDialog
        title: qsTr("Pay failed!")
        icon: StandardIcon.Warning
        text: qsTr("Pay request failed.\nPlease try again.")
        standardButtons: MessageDialog.Ok
        onAccepted: openMainScreen()
    }

    StackLayout {
        id: mainLayout
        anchors.fill: parent
        currentIndex: 0

        WalletStackViewer {
            id: walletViewer
            pushScreen: generalTransitions()
            menuLoader: drawerLoader
        }

        SettingsScreen {
            id: settingsScreen
            pushScreen: generalTransitions()
        }
    }

    function generalTransitions() {
        var transitionsMap = {}
        transitionsMap["showMenu"] = showMenu
        transitionsMap["hideMenu"] = hideMenu
        transitionsMap["openMainScreen"] = openMainScreen
        return transitionsMap
    }

    function menuTransitions() {
        var transitionsMap = {}
        transitionsMap["hideMenu"] = hideMenu
        transitionsMap["openSettingsScreen"] = openSettingsScreen
        transitionsMap["openMainScreen"] = openMainScreen
        return transitionsMap
    }

    function openMainScreen() {
        mainLayout.currentIndex = 0
        selectButton("Wallet")
    }

    function openSettingsScreen() {
        mainLayout.currentIndex = 1
        selectButton("Settings")
    }

    function showMenu() {
        drawerLoader.item.open()
    }

    function hideMenu() {
        drawerLoader.item.close()
    }

    function selectButton(name) {
        if (Qt.platform.os === "ios") {
            footerLoader.item.seclectedButtonChanged(name)
        }
    }
}
