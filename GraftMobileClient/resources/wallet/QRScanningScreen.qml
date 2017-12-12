import QtQuick 2.9
import QtQuick.Dialogs 1.2
import "../components"
import "../"

BaseScreen {
    title: qsTr("Pay")
    screenHeader {
        navigationButtonState: Qt.platform.os !== "android"
    }

    Connections {
        target: GraftClient

        onGetPOSDataReceived: {
            if (result === true) {
                pushScreen.openPaymentConfirmationScreen()
            }
            else {
                messageDialog.open()
                pushScreen.openMainScreen()
            }
         }
    }

    MessageDialog {
        id: messageDialog
        title: qsTr("Attention")
        icon: StandardIcon.Warning
        text: qsTr("QR Code data is wrong. \nPlease, scan correct QR Code.")
    }

    QRScanningView {
        anchors.fill: parent
        onQrCodeDetected: GraftClient.getPOSData(message)
    }
}
