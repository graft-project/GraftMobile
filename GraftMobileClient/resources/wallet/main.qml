import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../"

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
            drawerLoader.item.width = 0.75 * root.width
            drawerLoader.item.height = root.height
            drawerLoader.item.pushScreen = transitionsBetweenScreens()
            drawerLoader.item.balanceInGraft = "1.14"
        }
    }

    Component.onCompleted: {
        if (Qt.platform.os !== "ios") {
            drawerLoader.source = "qrc:/wallet/GraftMenu.qml"
        }
    }

    footer: GraftToolBar {
        pushScreen: transitionsBetweenScreens()
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

    BalanceView {
        id: initialScreen
        amountGraft: 1.2
        amountMoney: 145
        pushScreen: transitionsBetweenScreens()
    }

    function transitionsBetweenScreens() {
        var transitionsMap = {}
        transitionsMap["showMenu"] = showMenu
        transitionsMap["hideMenu"] = hideMenu
        transitionsMap["goBack"] = goBack
        transitionsMap["addCardScreen"] = openAddCardScreen
        transitionsMap["openBalanceScreen"] = openBalanceScreen
        transitionsMap["openQRCodeScanner"] = openQRScanningScreen
        transitionsMap["paymentScreen"] = openPaymentConfirmationView
        return transitionsMap
    }

    function openQRScanningScreen() {
        stack.push("qrc:/QRScanningScreen.qml", {"pushScreen": transitionsBetweenScreens()})
    }

    function openAddCardScreen() {
        stack.push("qrc:/wallet/AddCardView.qml", {"pushScreen": transitionsBetweenScreens()})
    }

    function openPaymentConfirmationView() {
        stack.push("PaymentConfirmationView.qml", {"pushScreen": transitionsBetweenScreens(),
                       "totalAmount": GraftClient.totalCost(),
                       "currencyModel": currencyModel,
                       "balanceInGraft": balanceInGraft,
                       "balanceInUSD": balanceInUSD,
                       "productModel": PaymentProductModel})
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

    function openBalanceScreen() {
        stack.pop(initialScreen)
    }
}
