import QtQuick 2.9
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import org.graft 1.0
import com.device.platform 1.0
import "../"
import "../components"

GraftApplicationWindow {
    id: root
    title: qsTr("Graft Point-of-Sale")
    handleBackEvent: mainLayout.backButtonHandler

    Loader {
        id: drawerLoader
        onLoaded: {
            drawerLoader.item.pushScreen = menuTransitions()
            drawerLoader.item.balanceInGraft = GraftClient.balance(GraftClientTools.UnlockedBalance)
            drawerLoader.item.interactive = mainLayout.currentIndex !== 0
        }
    }

    footer: Item {
        id: graftApplicationFooter
        height: Detector.isPlatform(Platform.IOS | Platform.Desktop) ?
                Detector.bottomNavigationBarHeight() + 49 : 0
        visible: !createWalletStackViewer.visible

        Loader {
            id: footerLoader
            anchors.fill: parent
            onLoaded: footerLoader.item.pushScreen = menuTransitions()
        }
    }

    Component.onCompleted: {
        if (Detector.isPlatform(Platform.IOS | Platform.Desktop)) {
            footerLoader.source = "qrc:/pos/GraftToolBar.qml"
        } else {
            drawerLoader.source = "qrc:/pos/GraftMenu.qml"
        }
    }

    Connections {
        target: GraftClient
        onErrorReceived: {
            var checkDialog = Detector.isDesktop() ? desktopMessageDialog : mobileMessageDialog
            if (message !== "") {
                checkDialog.title = qsTr("Network Error")
                checkDialog.text = message
            } else {
                checkDialog.title = qsTr("Sale failed!")
                checkDialog.text = qsTr("Sale request failed.\nPlease try again.")
            }
            checkDialog.open()
        }
    }

    DesktopDialog {
        id: desktopMessageDialog
        width: parent.width / 1.2 - 20
        topMargin: (parent.height - desktopMessageDialog.height) / 2
        leftMargin: (parent.width - desktopMessageDialog.width) / 2
        title: qsTr("Sale failed!")
        text: qsTr("Sale request failed.\nPlease try again.")
        onConfirmed: {
            mainLayout.enableScreen()
            checkAccountExists()
            desktopMessageDialog.close()
        }
    }

    MessageDialog {
        id: mobileMessageDialog
        icon: StandardIcon.Warning
        title: qsTr("Sale failed!")
        text: qsTr("Sale request failed.\nPlease try again.")
        onAccepted: {
            mainLayout.enableScreen()
            checkAccountExists()
            mobileMessageDialog.close()
        }
    }

    SwipeView {
        id: mainLayout
        focus: true
        anchors.fill: parent
        interactive: false
        currentIndex: GraftClient.isAccountExists() ? 1 : 0
        onCurrentIndexChanged: {
            if (Detector.isPlatform(Platform.IOS | Platform.Desktop)) {
                graftApplicationFooter.visible = currentIndex !== 0
            } else if (drawerLoader && drawerLoader.status === Loader.Ready) {
                drawerLoader.item.interactive = currentIndex !== 0
            }
        }

        CreateWalletStackViewer {
            id: createWalletStackViewer
            pushScreen: generalTransitions()
            menuLoader: drawerLoader
            isActive: SwipeView.isCurrentItem
        }

        ProductStackViewer {
            id: productViewer
            pushScreen: generalTransitions()
            menuLoader: drawerLoader
            isActive: SwipeView.isCurrentItem
        }

        InfoWalletStackViewer {
            id: infoWalletViewer
            pushScreen: generalTransitions()
            menuLoader: drawerLoader
            isActive: SwipeView.isCurrentItem
        }

        SettingsStackViewer {
            id: settingsStackViewer
            pushScreen: generalTransitions()
            appType: "pos"
            isActive: SwipeView.isCurrentItem
        }

        BlogScreen {
            id: blogScreen
            pushScreen: generalTransitions()
        }

        function backButtonHandler() {
            if (!currentItem.backButtonHandler()) {
                if (!allowClose) {
                    showCloseLabel()
                } else {
                    Qt.quit()
                }
                allowClose = !allowClose
            }
        }

        function enableScreen() {
            currentItem.enableScreen()
        }
    }

    function generalTransitions() {
        var transitionsMap = {}
        transitionsMap["showMenu"] = showMenu
        transitionsMap["hideMenu"] = hideMenu
        transitionsMap["openMainScreen"] = openMainScreen
        transitionsMap["privateClearChecked"] = privateClearChecked
        transitionsMap["openCreateWalletStackViewer"] = openCreateWalletStackViewer
        return transitionsMap
    }

    function menuTransitions() {
        var transitionsMap = {}
        transitionsMap["hideMenu"] = hideMenu
        transitionsMap["openMainScreen"] = openMainScreen
        transitionsMap["openBlogScreen"] = openBlogScreen
        transitionsMap["openWalletScreen"] = openWalletScreen
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

    function openWalletScreen() {
        mainLayout.currentIndex = 2
        selectButton("Wallet")
    }

    function openSettingsScreen() {
        console.log("main.openSettingsScreen")
        mainLayout.currentIndex = 3
        selectButton("Settings")
    }

    function privateClearChecked() {
        selectButton("Store")
        ProductModel.clearSelections()
    }

    function openCreateWalletStackViewer() {
        clearStackViewers()
        mainLayout.currentIndex = 0
    }

    function selectButton(name) {
        if (Detector.isPlatform(Platform.IOS | Platform.Desktop)) {
            footerLoader.item.seclectedButtonChanged(name)
        }
    }

    function clearStackViewers() {
        for (var i = 0; i < mainLayout.count; ++i) {
            if (mainLayout.itemAt(i).clearStackViewer !== undefined) {
                mainLayout.itemAt(i).clearStackViewer()
            }
        }
    }

    function checkAccountExists() {
        if (GraftClient.isAccountExists()) {
            productViewer.clearChecked()
        }
    }

    function openBlogScreen() {
        mainLayout.currentIndex = 4
        selectButton("About")
    }
}
