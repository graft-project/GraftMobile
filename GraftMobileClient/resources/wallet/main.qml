import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../"

ApplicationWindow {
    id: root
    visible: true
    width: 320
    height: 480
    title: qsTr("WALLET")

    header: Header {
        id: mainHader
        headerText: qsTr("Wallet")

        onClickMenuIcon: {
            menuState = true
            stack.pop()
        }
    }

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: initialScreen
    }

    BalanceView {
        id: initialScreen
        amountGraft: 2
        amountMoney: 145
        onPayButtonClicked: openQRScanningScreen()
    }

    function openQRScanningScreen()
    {
        var componentQRScanningScreen = Qt.createComponent("qrc:/QRScanningScreen.qml");
        var qrCodeScanScreen = componentQRScanningScreen.createObject(root);
        mainHader.headerText = qsTr("Pay")
        mainHader.menuState = false
        qrCodeScanScreen.detectQRCode.connect(openPaymetnConfirmationView)
        stack.push(qrCodeScanScreen)
    }

    function openPaymetnConfirmationView()
    {
        var componentPaymentConfirmationView = Qt.createComponent("qrc:/wallet/PaymentConfirmationView.qml");
        var paymentConfirmationView = componentPaymentConfirmationView.createObject(root);
        stack.push(paymentConfirmationView)
    }
}

