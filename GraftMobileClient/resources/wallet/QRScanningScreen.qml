import QtQuick 2.9
import QtQuick.Dialogs 1.2
import com.device.platform 1.0
import "../components"
import "../"

BaseScreen {
    id: qrScanning
    title: qsTr("Pay")
    screenHeader {
        navigationButtonState: Detector.isPlatform(Platform.IOS | Platform.Desktop)
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
}
