import QtQuick 2.9
import QtQuick.Dialogs 1.2
import com.device.platform 1.0
import "../components"
import "../"

BaseScreen {
    id: qrScanning
    title: qsTr("Pay")

    Component.onCompleted: {
        if (Detector.isPlatform(Platform.IOS)) {
            qrScanning.specialBackMode = pop
        }
    }

    Connections {
        target: GraftClient

        onGetPOSDataReceived: {
            if (result === true) {
                pushScreen.openPaymentConfirmationScreen()
            } else {
                screenDialog.text = qsTr("QR Code data is wrong. \nPlease, scan correct QR Code.")
                screenDialog.open()
            }
        }
    }


    Connections {
        target: qrScanning
        onAttentionAccepted: qRScanningView.resetView()
    }

    QRScanningView {
        id: qRScanningView
        anchors.fill: parent
        onQrCodeDetected: GraftClient.getPOSData(message)
    }

    function pop() {
        IOSCameraPermission.stopTimer()
        goBack()
    }
}
