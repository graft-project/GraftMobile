import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick 2.9
import "../"

GraftApplicationWindow {
    id: root
    title: qsTr("POS")
    property var drawer

    Loader {
        id: drawerLoader
        onLoaded: {
            drawer = drawerLoader.item
            drawerLoader.item.pushScreen = screenTransitions()
            drawerLoader.item.balanceInGraft = "1.14"
        }
    }

    footer: Loader {
        id: footerLoader
        onLoaded: footerLoader.item.pushScreen = screenTransitions()
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
            messageDialog.open()
        }
    }

    MessageDialog {
        id: messageDialog
        title: qsTr("Sale failed!")
        icon: StandardIcon.Warning
        text: qsTr("Sale request failed.\nPlease try again.")
        standardButtons: MessageDialog.Ok
        onAccepted: clearChecked()
    }

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: mainScreen
        focus: true
        Keys.onReleased: {
            if (!busy && (event.key === Qt.Key_Back || event.key === Qt.Key_Escape)) {
                pop()
                event.accepted = true
            }
        }
    }

    ProductScreen {
        id: mainScreen
        pushScreen: screenTransitions()
    }

    function screenTransitions() {
        var transitionsMap = {}
        transitionsMap["showMenu"] = showMenu
        transitionsMap["hideMenu"] = hideMenu
        transitionsMap["openEditingItemScreen"] = openEditingItemScreen
        transitionsMap["openQuickDealScreen"] = openQuickDealScreen
        transitionsMap["initializingCheckout"] = openCartScreen
        transitionsMap["openWalletScreen"] = openInfoWalletScreen
        transitionsMap["openMainScreen"] = openMainScreen
        transitionsMap["openSettingsScreen"] = openSettingsScreen
        transitionsMap["openPaymentScreen"] = openPaymentScreen
        transitionsMap["openAddAccountScreen"] = openAddAccountScreen
        transitionsMap["goBack"] = turnBack
        transitionsMap["clearChecked"] = clearChecked
        return transitionsMap
    }

    function showMenu() {
        drawer.open()
    }

    function hideMenu() {
        drawer.close()
    }

    function openEditingItemScreen(index) {
        stack.push("qrc:/pos/EditingItemScreen.qml", {"pushScreen": screenTransitions(),
                       "currencyModel": CurrencyModel, "index": index})
    }

    function openQuickDealScreen() {
        stack.push("qrc:/pos/QuickDialScreen.qml", {"pushScreen": screenTransitions(),
                   "textLabel": qsTr("Quick Dial"), "currencyModel": CurrencyModel})
    }

    function openCartScreen() {
        stack.push("qrc:/pos/CartScreen.qml", {"pushScreen": screenTransitions(),
                       "price": ProductModel.totalCost()})
    }

    function openPaymentScreen() {
        stack.push("qrc:/PaymentScreen.qml", {"pushScreen": clearChecked,
                       "title": qsTr("Cart"), "textLabel": qsTr("Checkout complete!"),
                       "isSpacing": false})
    }

    function openInfoWalletScreen() {
        selectButton("Wallet")
        stack.push("qrc:/pos/InfoWalletScreen.qml", {"pushScreen": screenTransitions(),
                   "amountMoney": 145, "amountGraft": 1.14})
    }

    function openMainScreen() {
        selectButton("Store")
        stack.pop(mainScreen)
    }

    function openSettingsScreen() {
        selectButton("Settings")
        stack.push("qrc:/pos/SettingsScreen.qml", {"pushScreen": screenTransitions()})
    }

    function openAddAccountScreen() {
        stack.push("qrc:/AddAccountScreen.qml", {"pushScreen": screenTransitions(),
                   "coinModel": CoinModel})
    }

    function turnBack() {
        stack.pop()
    }

    function clearChecked() {
        selectButton("Store")
        ProductModel.clearSelections()
        stack.pop(mainScreen)
    }

    function selectButton(name)
    {
        if (Qt.platform.os === "ios") {
            switch (name) {
                case "Store": footerLoader.item.seclectedButtonChanged(name); break;
                case "Wallet": footerLoader.item.seclectedButtonChanged(name); break;
                case "Settings": footerLoader.item.seclectedButtonChanged(name); break;
            }
        }
    }
}
