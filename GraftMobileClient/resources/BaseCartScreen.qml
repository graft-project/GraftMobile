import QtQuick 2.9
import com.device.platform 1.0
import "components"

BaseScreen {
    property real price: 0

    signal screenClosed()

    title: qsTr("Cart")
    screenHeader {
        isNavigationButtonVisible: false
        navigationButtonState: true
//        navigationButtonState: Detector.isPlatform(Platform.Android)
    }

    Connections {
        target: GraftClient

        onSaleStatusReceived: {
            screenClosed()
            pushScreen.openPaymentScreen(result)
        }
    }

    function rejectSale() {
        GraftClient.rejectSale()
        pushScreen.clearChecked()
    }
}
