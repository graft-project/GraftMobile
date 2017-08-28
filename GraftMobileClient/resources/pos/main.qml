import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../"

ApplicationWindow {
    visible: true
    width: 320
    height: 480
    title: qsTr("POS")

    Drawer {
        id: drawer
        width: 0.75 * parent.width
        height: parent.height
        contentItem: PosMenu {
            anchors.fill: parent
            balanceInGraft: "1.15"
            pushScreen: menuPush()
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
        pushScreen: productPush()
    }

    function productPush() {
        var transitionsMap = {}
        transitionsMap["openAddScreen"] = openAddingScreen
        transitionsMap["initialCheckout"] = openPaymentScreen
        return transitionsMap
    }

    function menuPush() {
        var transitionsMap = {}
        transitionsMap["openWalletScreen"] = openInfoWalletScreen
        transitionsMap["backProductScreen"] = rootScreen
        return transitionsMap
    }

    function rootScreen() {
        stack.pop(mainScreen)
    }

    function openAddingScreen() {
        stack.push("qrc:/pos/AddingScreen.qml", {"pushScreen": rootScreen,
                       "currencyModel": [qsTr("USD"), qsTr("GRAFT")]})
    }

    function openPaymentScreen() {
        stack.push("qrc:/pos/PaymentScreen.qml", {"pushScreen": rootScreen})
    }

    function openInfoWalletScreen() {
        stack.push("qrc:/pos/InfoWallet.qml")
    }

}
