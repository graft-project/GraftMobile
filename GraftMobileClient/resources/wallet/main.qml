import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../"

ApplicationWindow {
    id: root
    visible: true
    width: 320
    height: 480
    title: qsTr("WALLET")

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
        stack.push("qrc:/QRScanningScreen.qml", {"pushScreen": openPaymentConfirmationView})
    }

    function openPaymentConfirmationView() {
        stack.push("PaymentConfirmationView.qml", {"pushScreen": openBalanceScreen})
    }

    function openBalanceScreen() {
        stack.pop(initialScreen)
    }
}

