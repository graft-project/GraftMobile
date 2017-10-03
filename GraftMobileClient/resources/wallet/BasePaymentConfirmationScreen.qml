import QtQuick 2.9
import "../"
import "../components"

BaseScreen {
    id: root

    title: qsTr("Pay")

    Connections {
        target: GraftClient

        onPayReceived: {
            if (result != true) {
                pushScreen.openBalanceScreen()
            }
        }

        onPayStatusReceived: {
            if (result != true) {
                pushScreen.openBalanceScreen()
            }
        }
    }

    function confirmPay() {
        GraftClient.pay()
        //TODO: go to the PaymentScreen(POS and Wallet)
    }

    function cancelPay() {
        GraftClient.rejectPay()
        pushScreen.openBalanceScreen()
    }
}
