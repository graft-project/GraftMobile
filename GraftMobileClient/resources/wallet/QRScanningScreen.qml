import QtQuick 2.9
import "../components"
import "../"

BaseScreen {
    title: qsTr("Pay")
    screenHeader {
        navigationButtonState: Qt.platform.os !== "android"
    }

    Connections {
        target: GraftClient

        onReadyToPayReceived: {
            if (result === true) {
                pushScreen.openPaymentConfirmationScreen()
            }
            else {
                pushScreen.openMainScreen()
            }
         }
    }

    QRScanningView {
        anchors.fill: parent
        onQrCodeDetected: GraftClient.readyToPay(message)
    }
}
