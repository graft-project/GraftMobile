import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../"

ApplicationWindow {
    id: root

    property int totalAmount: 100
    property var currencyModel: ["Graft", "USD"]
    property int balanceInGraft: 1
    property int balanceInUSD: 200

    visible: true
    width: 320
    height: 480
    title: qsTr("WALLET")

    Drawer {
        id: drawer
        width: 0.75 * parent.width
        height: parent.height
        contentItem: GraftMenu {
                        model: ["Graft", "USD"]
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

    BalanceView {
        id: initialScreen
        amountGraft: 2
        amountMoney: 145
        pushScreen: openQRScanningScreen
    }

    function openQRScanningScreen() {
        var transitionsMap = {}
        transitionsMap["balanceScreen"] = openBalanceScreen
        transitionsMap["paymentScreen"] = openPaymentConfirmationView
        stack.push("qrc:/QRScanningScreen.qml", {"pushScreen": transitionsMap})
    }

    function openPaymentConfirmationView() {
        stack.push("PaymentConfirmationView.qml", {"pushScreen": openBalanceScreen,
                                                   "totalAmount": totalAmount,
                                                   "currencyModel": currencyModel,
                                                   "balanceInGraft": balanceInGraft,
                                                   "balanceInUSD": balanceInUSD})
    }

    function openBalanceScreen() {
        stack.pop(initialScreen)
    }
}

