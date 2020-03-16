import QtQuick 2.9
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.2
import com.device.platform 1.0
import org.navigation.attached.properties 1.0
import "../components"
import "../"

BaseScreen {
    id: sendOrScanScreen
    title: qsTr("Pay")
    specialBackMode: Detector.isPlatform(Platform.IOS) ? pop : goBack

    Connections {
        target: sendOrScanScreen
        onAttentionAccepted: qRScanningView.resetView()
    }

    QRScanningView {
        id: qRScanningView
        anchors.fill: parent
        KeyNavigation.tab: sendOrScanScreen.Navigation.implicitFirstComponent
        KeyNavigation.backtab: sendOrScanScreen.Navigation.implicitFirstComponent
        onQrCodeDetected: {
            if (GraftClient.isSaleQrCodeValid(message)) {
                GraftClient.saleDetails(message)
                pushScreen.openPaymentConfirmationScreen()
            } else {
                screenDialog.text = qsTr("QR Code data is wrong. \nPlease, scan correct QR Code.")
                screenDialog.open()
            }
        }
    }

    /*
    Button {
        width: parent.width
        height: 50
      
        onClicked: {
            console.log("Clicked")
            GraftClient.saleDetails("debug")
        }
    }
    */
    

    function pop() {
        qRScanningView.stopScanningView()
        goBack()
    }
}
