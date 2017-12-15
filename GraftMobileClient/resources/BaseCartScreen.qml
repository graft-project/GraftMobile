import QtQuick 2.9
import "components"

BaseScreen {
    property real price: 0

    signal screenClosed()

    title: qsTr("Cart")
    screenHeader {
        navigationButtonState: Qt.platform.os === "android"
    }

    Connections {
        target: GraftClient

        onSaleStatusReceived: {
            screenClosed()

            if (result === true) {
                pushScreen.openPaymentScreen(result)
            }
        }
    }

    function rejectSale() {
        GraftClient.rejectSale()
        pushScreen.clearChecked()
    }
}
