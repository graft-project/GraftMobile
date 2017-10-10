import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
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
            openMainScreen()
        }
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
        transitionsMap["initializingCheckout"] = openCartScreen
        transitionsMap["openWalletScreen"] = openInfoWalletScreen
        transitionsMap["openProductScreen"] = openMainScreen
        transitionsMap["openSettingsScreen"] = openSettingsScreen
        transitionsMap["openPaymentScreen"] = openPaymentScreen
        transitionsMap["goBack"] = turnBack
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

    function openCartScreen() {
        stack.push("qrc:/pos/CartScreen.qml", {"pushScreen": screenTransitions(),
                       "price": ProductModel.totalCost()})
    }

    function openPaymentScreen() {
        stack.push("qrc:/PaymentScreen.qml", {"pushScreen": openMainScreen,
                       "title": qsTr("Cart"), "textLabel": qsTr("Checkout complete!")})
    }

    function openInfoWalletScreen() {
        stack.push("qrc:/pos/InfoWalletScreen.qml", {"pushScreen": screenTransitions(),
                   "amountMoney": 145, "amountGraft": 1.14})
    }

    function openMainScreen() {
        stack.pop(mainScreen)
    }

    function openSettingsScreen() {
        stack.push("qrc:/pos/SettingsScreen.qml", {"pushScreen": screenTransitions()})
    }

    function turnBack() {
        stack.pop()
    }
}
