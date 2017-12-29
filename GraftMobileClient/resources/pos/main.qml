import QtQuick 2.9
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import org.graft 1.0
import "../"
import "../components"

GraftApplicationWindow {
    id: root
    title: qsTr("POS")

    Loader {
        id: drawerLoader
        onLoaded: {
            drawerLoader.item.pushScreen = menuTransitions()
            drawerLoader.item.balanceInGraft = GraftClient.balance(GraftClientTools.UnlockedBalance)
            drawerLoader.item.interactive = !createWalletStackViewer.visible
        }
    }

    footer: Item {
        id: graftApplicationFooter
        height: Qt.platform.os === "ios" ? 49 : 0
        visible: !createWalletStackViewer.visible

        Loader {
            id: footerLoader
            anchors.fill: parent
            onLoaded: footerLoader.item.pushScreen = menuTransitions()
        }
    }

    Component.onCompleted: {
        if (Qt.platform.os === "ios") {
            footerLoader.source = "qrc:/pos/GraftToolBar.qml"
        } else {
            drawerLoader.source = "qrc:/pos/GraftMenu.qml"
        }
    }

    Connections {
        target: GraftClient

        onErrorReceived: {
            if (message !== "") {
                messageDialog.title = qsTr("Network Error")
                messageDialog.text = message
            } else {
                messageDialog.title = qsTr("Sale failed!")
                messageDialog.text = qsTr("Sale request failed.\nPlease try again.")
            }
            messageDialog.open()
        }
    }

    MessageDialog {
        id: messageDialog
        title: qsTr("Sale failed!")
        icon: StandardIcon.Warning
        text: qsTr("Sale request failed.\nPlease try again.")
        standardButtons: MessageDialog.Ok
        onAccepted: productViewer.clearChecked()
    }

    StackLayout {
        id: mainLayout
        anchors.fill: parent
        currentIndex: GraftClient.isAccountExists() ? 1 : 0

        CreateWalletStackViewer {
            id: createWalletStackViewer
            pushScreen: generalTransitions()
            menuLoader: drawerLoader
            onVisibleChanged: {
                if (Qt.platform.os === "ios") {
                    graftApplicationFooter.visible = !visible
                } else {
                    drawerLoader.item.interactive = !visible
                }
            }
        }

        ProductStackViewer {
            id: productViewer
            pushScreen: generalTransitions()
            menuLoader: drawerLoader
        }

        InfoWalletStackViewer {
            id: infoWalletViewer
            pushScreen: generalTransitions()
            menuLoader: drawerLoader
        }

        SettingsStackViewer {
            id: settingsStackViewer
            pushScreen: generalTransitions()
            appType: "pos"
        }
    }

    function generalTransitions() {
        var transitionsMap = {}
        transitionsMap["showMenu"] = showMenu
        transitionsMap["hideMenu"] = hideMenu
        transitionsMap["openMainScreen"] = openMainScreen
        transitionsMap["privateClearChecked"] = privateClearChecked
        return transitionsMap
    }

    function menuTransitions() {
        var transitionsMap = {}
        transitionsMap["hideMenu"] = hideMenu
        transitionsMap["openMainScreen"] = openMainScreen
        transitionsMap["openWalletScreen"] = openInfoWalletScreen
        transitionsMap["openSettingsScreen"] = openSettingsScreen
        return transitionsMap
    }

    function showMenu() {
        drawerLoader.item.open()
    }

    function hideMenu() {
        drawerLoader.item.close()
    }

    function openMainScreen() {
        mainLayout.currentIndex = 1
        selectButton("Store")
    }

    function openInfoWalletScreen() {
        mainLayout.currentIndex = 2
        selectButton("Wallet")
    }

    function openSettingsScreen() {
        mainLayout.currentIndex = 3
        selectButton("Settings")
    }

    function privateClearChecked() {
          selectButton("Store")
          ProductModel.clearSelections()
    }

    function selectButton(name) {
        if (Qt.platform.os === "ios") {
            footerLoader.item.seclectedButtonChanged(name)
        }
    }
}
