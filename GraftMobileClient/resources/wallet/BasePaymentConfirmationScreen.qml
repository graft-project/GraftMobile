import QtQuick 2.9
import "../"
import "../components"

BaseScreen {
    id: root

    property real totalAmount: 0
    property var productModel

    title: qsTr("Pay")
    screenHeader {
        navigationButtonState: Qt.platform.os === "android"
    }

    Connections {
        target: GraftClient

        onPayReceived: {
            if (result !== true) {
                pushScreen.openMainScreen()
            }
        }

        onPayStatusReceived: {
            if (result === true) {
                pushScreen.openPaymentScreen()
            } else {
                pushScreen.openMainScreen()
            }
        }
    }

    function confirmPay() {
        GraftClient.pay()
    }

    function cancelPay() {
        GraftClient.rejectPay()
        pushScreen.openMainScreen()
    }
}
