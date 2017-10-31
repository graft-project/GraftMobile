import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../"
import "../components"

GraftApplicationWindow {
    id: root
    title: qsTr("WALLET")

    property real totalAmount: 100
    property var currencyModel: ["Graft", "USD"]
    property real balanceInGraft: 1
    property real balanceInUSD: 200
    property var drawer

    Loader {
        id: drawerLoader
        onLoaded: {
            drawer = drawerLoader.item
            drawerLoader.item.pushScreen = transitionsBetweenScreens()
            drawerLoader.item.balanceInGraft = "1.14"
        }
    }

    footer: Loader {
        id: footerLoader
        onLoaded: footerLoader.item.pushScreen = transitionsBetweenScreens()
    }

    Component.onCompleted: {
        if (Qt.platform.os === "ios") {
            footerLoader.source = "qrc:/wallet/GraftToolBar.qml"
        } else {
            drawerLoader.source = "qrc:/wallet/GraftMenu.qml"
        }
    }

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: initialScreen
        focus: true
        Keys.onReleased: {
            if (!busy && (event.key === Qt.Key_Back || event.key === Qt.Key_Escape)) {
                pop()
                event.accepted = true
            }
        }
    }

    BalanceScreen {
        id: initialScreen
        amountGraft: 1.14
        amountMoney: 145
        pushScreen: transitionsBetweenScreens()
    }

    function transitionsBetweenScreens() {
        var transitionsMap = {}
        transitionsMap["showMenu"] = showMenu
        transitionsMap["hideMenu"] = hideMenu
        transitionsMap["goBack"] = goBack
        transitionsMap["openQRCodeScanner"] = openQRScanningScreen
        transitionsMap["addCardScreen"] = openAddCardScreen
        transitionsMap["openPaymentConfirmationScreen"] = openPaymentConfirmationScreen
        transitionsMap["openPaymentScreen"] = openPaymentScreen
        transitionsMap["openAddAccountScreen"] = openAddAccountScreen
        transitionsMap["openBalanceScreen"] = openBalanceScreen
        return transitionsMap
    }

    function showMenu() {
        drawer.open()
    }

    function hideMenu() {
        drawer.close()
    }

    function goBack() {
        stack.pop()
    }

    function openQRScanningScreen() {
        stack.push("qrc:/QRScanningScreen.qml", {"pushScreen": transitionsBetweenScreens()})
    }

    function openAddCardScreen() {
        stack.push("qrc:/wallet/AddCardScreen.qml", {"pushScreen": transitionsBetweenScreens()})
    }

    function openPaymentConfirmationScreen() {
        stack.push("qrc:/wallet/PaymentConfirmationScreen.qml", {"pushScreen": transitionsBetweenScreens(),
                       "totalAmount": GraftClient.totalCost(),
                       "currencyModel": currencyModel,
                       "balanceInGraft": balanceInGraft,
                       "balanceInUSD": balanceInUSD,
                       "productModel": PaymentProductModel})
    }

    function openPaymentScreen() {
        stack.push("qrc:/PaymentScreen.qml", {"pushScreen": openBalanceScreen,
                       "title": qsTr("Pay"), "textLabel": qsTr("Paid complete!")})
    }

    function openAddAccountScreen() {
        stack.push("qrc:/wallet/AddAccountScreen.qml", {"pushScreen": transitionsBetweenScreens(),
                   "coinModel": CoinModel})
    }

    function openBalanceScreen() {
        stack.pop(initialScreen)
    }
}
