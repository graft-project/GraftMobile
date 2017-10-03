import QtQuick 2.0
import "components"

BaseScreen {

    Connections {
        target: GraftClient

        onSaleStatusReceived: {
            if (result === true) {
                pushScreen.openCompleteScreen()
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
