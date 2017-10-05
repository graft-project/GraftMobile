import QtQuick 2.0
import "components"

BaseScreen {
    property real price: 0
    title: qsTr("Cart")

    Connections {
        target: GraftClient

        onSaleStatusReceived: {
            if (result === true) {
                pushScreen.openPaymentScreen()
            } else {
                pushScreen.openProductScreen()
            }
        }
    }

    function rejectSale() {
        GraftClient.rejectSale()
        pushScreen.openProductScreen()
    }
}
