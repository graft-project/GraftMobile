import QtQuick 2.9
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.device.platform 1.0
import org.graft 1.0
import "components"

BaseScreen {
    id: sendCoinScreen
    title: qsTr("Send")
    screenHeader.actionButtonState: true
    action: checkingData
    onErrorMessage: busyIndicator.running = false

    Component.onCompleted: {
        if (Detector.isPlatform(Platform.IOS | Platform.Desktop)) {
            screenHeader.actionText = qsTr("Send")
        }
    }

    Connections {
        target: GraftClient

        onTransferFeeReceived: {
            busyIndicator.running = false
            enableScreen()
            if (result) {
                pushScreen.openSendConfirmationScreen(receiversAddress.text, coinsAmountTextField.text, fee)
            }
        }
    }

    StackLayout {
        id: stackLayout
        anchors.fill: parent
        onCurrentIndexChanged: {
            if (currentIndex === 1) {
                sendCoinScreen.enabled = true
                sendCoinScreen.screenHeader.actionButtonState = false
                sendCoinScreen.specialBackMode = changeBehaviorButton
            } else {
                sendCoinScreen.screenHeader.actionButtonState = true
                sendCoinScreen.specialBackMode = null
            }
        }

        Item {
            ColumnLayout {
                anchors {
                    fill: parent
                    margins: 15
                }
                spacing: 0

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop

                    LinearEditItem {
                        id: receiversAddress
                        Layout.fillWidth: true
                        Layout.preferredHeight: 130
                        maximumLength: 110
                        wrapMode: TextField.WrapAnywhere
                        inputMethodHints: Qt.ImhNoPredictiveText
                        title: Detector.isPlatform(Platform.IOS | Platform.Desktop) ?
                               qsTr("Receiver's address:") : qsTr("Receiver's address")
                    }

                    LinearEditItem {
                        id: coinsAmountTextField
                        Layout.fillWidth: true
                        title: Detector.isPlatform(Platform.IOS | Platform.Desktop) ?
                               qsTr("Amount:") : qsTr("Amount")
                        showLengthIndicator: false
                        inputMethodHints: Qt.ImhDigitsOnly
                        validator: RegExpValidator {
                            regExp: /^(([0-9]){1,6}|([0-9]){1,6}\.([0-9]){1,4})$/g
                        }
                    }

                    Label {
                        anchors {
                            right: coinsAmountTextField.right
                            verticalCenter: coinsAmountTextField.verticalCenter
                            verticalCenterOffset: Detector.isDesktop() ? -8 : Detector.isPlatform(Platform.IOS) ? -5 : 3
                        }
                        color: "#BBBBBB"
                        font {
                            pixelSize: 16
                            bold: true
                        }
                        text: qsTr("GRFT")
                    }
                }

                Item {
                    Layout.fillHeight: true
                }

                WideActionButton {
                    id: scanQRcodeButton
                    Layout.fillWidth: true
                    text: qsTr("Scan QR Code")
                    onClicked: {
                        sendCoinScreen.enabled = false
                        stackLayout.currentIndex = 1
                    }
                }

                WideActionButton {
                    id: sendCoinsButton
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignBottom
                    text: qsTr("Send")
                    onClicked: checkingData()
                }
            }
        }

        QRScanningView {
            onQrCodeDetected: {
                receiversAddress.text = message
                changeBehaviorButton()
            }
        }
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: false
    }

    function changeBehaviorButton() {
        stackLayout.currentIndex = 0
    }

    function checkingData() {
        if ((1 > receiversAddress.text.length) || (receiversAddress.text.length > 110)) {
            screenDialog.text = qsTr("You entered the wrong account number! Please input correct account number.")
            screenDialog.open()
        } else if ((0.0001 > coinsAmountTextField.text) || (coinsAmountTextField.text > 100000.0)) {
            screenDialog.title = qsTr("Input error")
            screenDialog.text = qsTr("The amount must be more than 0 and less than 100 000! Please input correct value.")
            screenDialog.open()
        } else if (GraftClient.balance(GraftClientTools.UnlockedBalance) < coinsAmountTextField.text) {
            screenDialog.title = qsTr("Input error")
            screenDialog.text = qsTr("The amount which you want to send is higher than you have on your wallet. Please, enter a smaller amount.")
            screenDialog.open()
        } else {
            disableScreen()
            busyIndicator.running = true
            GraftClient.transferFee(receiversAddress.text, coinsAmountTextField.text)
        }
    }
}
