import QtQuick 2.9
import "components"

BaseScreen {
    property real price: 0
    
    title: qsTr("Cart")
    screenHeader {
        navigationButtonState: Qt.platform.os === "android"
    }

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
        pushScreen.clearChecked()
    }
}
