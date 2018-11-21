import QtQuick 2.9
import QtQuick.Controls 2.2
import com.device.platform 1.0
import "../"
import "../components"

BaseScreen {
    id: root

    property var productModel
    property alias informing: message
    property alias processingIndicator: waitingIndicator
    property alias activityBusyIndicator: busyIndicator.running
    default property alias content: background.data

    onErrorMessage: busyIndicator.running = false

    onNetworkReplyError: pushScreen.openPaymentScreen(0, false)

    title: qsTr("Pay")
    screenHeader {
        isNavigationButtonVisible: Detector.isPlatform(Platform.Android)
        navigationButtonState: Detector.isPlatform(Platform.Android)
    }

    Connections {
        target: GraftClient

        onPayReceived: {
            if (result !== true) {
                pushScreen.openBalanceScreen()
            }
        }

        onPayStatusReceived: {
            if (result === true) {
                pushScreen.openPaymentScreen(result)
            }
        }
    }

    Item {
        id: background
        anchors.fill: parent
    }

    Label {
        id: message
        visible: false
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: 30
        }
        horizontalAlignment: Label.AlignHCenter
        color: "#50000000"
        font.pixelSize: 17
        text: qsTr("Waiting for payment details...")
    }

    BusyIndicator {
        id: waitingIndicator
        anchors.centerIn: parent
        running: false
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: false
    }

    function cancelPay() {
        GraftClient.rejectPay()
        pushScreen.openBalanceScreen()
    }

    function confirmPay() {
        disableScreen()
        GraftClient.pay()
    }
}
