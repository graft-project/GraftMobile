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
                screenDialog.text = qsTr("QR Code data is wrong. \nPlease, scan correct QR Code.")
                screenDialog.open()
                qRScanningView.reset()
                console.log("ddddd")
//                qRScanningView.cameraReset.start()
            }
        }
    }

    QRScanningView {
        id: qRScanningView
        anchors.fill: parent
        onQrCodeDetected: GraftClient.getPOSData(message)
    }
}
