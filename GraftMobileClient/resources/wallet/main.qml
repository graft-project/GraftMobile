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
    title: qsTr("Graft Wallet")

    handleBackEvent: mainLayout.backButtonHandler

    Loader {
        id: drawerLoader
        onLoaded: {
            drawerLoader.item.pushScreen = menuTransitions()
            drawerLoader.item.balanceInGraft = GraftClient.balance(GraftClientTools.UnlockedBalance)
            drawerLoader.item.interactive = mainLayout.currentIndex > 1
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
            footerLoader.source = "qrc:/wallet/GraftToolBar.qml"
        } else {
            drawerLoader.source = "qrc:/wallet/GraftMenu.qml"
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
                checkDialog.title = qsTr("Pay failed!")
                checkDialog.text = qsTr("Pay request failed.\nPlease try again.")
            }
            checkDialog.open()
        }
    }

    DesktopDialog {
        id: desktopMessageDialog
        width: parent.width / 1.2 - 20
        topMargin: (parent.height - desktopMessageDialog.height) / 2
        leftMargin: (parent.width - desktopMessageDialog.width) / 2
        title: qsTr("Pay failed!")
        text: qsTr("Pay request failed.\nPlease try again.")
        onConfirmed: {
            mainLayout.enableScreen()
            checkAccountExists()
            desktopMessageDialog.close()
            mainLayout.currentItem.networkReplyError()
        }
    }

    MessageDialog {
        id: mobileMessageDialog
        title: qsTr("Pay failed!")
        icon: StandardIcon.Warning
        text: qsTr("Pay request failed.\nPlease try again.")
        onAccepted: {
            mainLayout.enableScreen()
            checkAccountExists()
            mobileMessageDialog.close()
            mainLayout.currentItem.networkReplyError()
        }
    }

    SwipeView {
        id: mainLayout
        anchors.fill: parent
        interactive: false
        currentIndex: GraftClient.settings("license") ? GraftClient.isAccountExists() ? 2 : 1 : 0
        onCurrentIndexChanged: {
            if (Detector.isPlatform(Platform.IOS | Platform.Desktop)) {
                graftApplicationFooter.visible = currentIndex > 1
            } else if (drawerLoader && drawerLoader.status === Loader.Ready) {
                drawerLoader.item.interactive = currentIndex > 1
            }
        }

        LicenseAgreementScreen {
            id: licenseScreen
            logoImage: "qrc:/imgs/graft-wallet-logo.png"
            acceptAction: acceptLicense
        }

        CreateWalletStackViewer {
            id: createWalletStackViewer
            pushScreen: generalTransitions()
            menuLoader: drawerLoader
            isActive: SwipeView.isCurrentItem
        }

        WalletStackViewer {
            id: walletViewer
            pushScreen: generalTransitions()
            menuLoader: drawerLoader
            isActive: SwipeView.isCurrentItem
        }

        SettingsStackViewer {
            id: settingsStackViewer
            pushScreen: generalTransitions()
            appType: "wallet"
            menuLoader: drawerLoader
            isActive: SwipeView.isCurrentItem
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
        transitionsMap["openCreateWalletStackViewer"] = openCreateWalletStackViewer
        return transitionsMap
    }

    function menuTransitions() {
        var transitionsMap = {}
        transitionsMap["hideMenu"] = hideMenu
        transitionsMap["openSettingsScreen"] = openSettingsScreen
        transitionsMap["openMainScreen"] = openMainScreen
        return transitionsMap
    }

    function showMenu() {
        drawerLoader.item.open()
    }

    function hideMenu() {
        drawerLoader.item.close()
    }

    function openMainScreen() {
        mainLayout.currentIndex = 2
        selectButton("Wallet")
    }

    function openCreateWalletStackViewer() {
        clearStackViewers()
        mainLayout.currentIndex = 1
    }

    function openSettingsScreen() {
        mainLayout.currentIndex = 3
        selectButton("Settings")
    }

    function selectButton(name) {
        if (Detector.isPlatform(Platform.IOS | Platform.Desktop)) {
            footerLoader.item.seclectedButtonChanged(name)
        }
    }

    function acceptLicense() {
        GraftClient.setSettings("license", true)
        GraftClient.saveSettings()
        if (GraftClient.isAccountExists()) {
            openMainScreen()
        } else {
            openCreateWalletStackViewer()
        }
    }

    function clearStackViewers() {
        for (var i = 1; i < mainLayout.count; ++i) {
            mainLayout.itemAt(i).clearStackViewer()
        }
    }

    function checkAccountExists() {
        if (GraftClient.isAccountExists()) {
            openMainScreen()
        }
    }
}
