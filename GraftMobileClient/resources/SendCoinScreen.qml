import QtQuick 2.9
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import "components"

BaseScreen {
    id: sendCoinScreen

    title: qsTr("Send")
    screenHeader {
        actionButtonState: true
        navigationButtonState: Qt.platform.os !== "android"
    }
    action: checkingData

    Component.onCompleted: {
        if (Qt.platform.os === "ios") {
            screenHeader.actionText = qsTr("Send")
        }
    }

    Connections {
        target: GraftClient

        onTransferReceived: {
            pushScreen.openPaymentScreen(result)
        }
    }

    StackLayout {
        id: stackLayout
        anchors.fill: parent
        onCurrentIndexChanged: {
            if (currentIndex === 1) {
                sendCoinScreen.screenHeader.actionButtonState = false
                sendCoinScreen.specialBackMode = changeBehaviorButton
            } else {
                sendCoinScreen.specialBackMode = null
                sendCoinScreen.screenHeader.actionButtonState = true
            }
        }

        Item {
            ColumnLayout {
                anchors {
                    fill: parent
                    topMargin: 15
                    leftMargin: 15
                    rightMargin: 15
                    bottomMargin: 15
                }
                spacing: 0

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop

                    LinearEditItem {
                        id: receiversAddress
                        Layout.fillWidth: true
                        Layout.maximumHeight: 130
                        maximumLength: 100
                        wrapMode: TextField.WrapAnywhere
                        inputMethodHints: Qt.ImhNoPredictiveText
                        title: Qt.platform.os === "ios" ? qsTr("Receivers address:") : qsTr("Receivers address")
                    }

                    LinearEditItem {
                        id: coinsAmountTextField
                        Layout.fillWidth: true
                        title: Qt.platform.os === "ios" ? qsTr("Amount:") : qsTr("Amount")
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
                            verticalCenterOffset: Qt.platform.os === "ios" ? -5 : 3
                        }
                        color: "#BBBBBB"
                        font {
                            pointSize: 16
                            bold: true
                        }
                        text: "GRF"
                    }
                }

                Item {
                    Layout.fillHeight: true
                }

                WideActionButton {
                    id: scanQRcodeButton
                    Layout.fillWidth: true
                    text: qsTr("Scan QR Code")
                    onClicked: stackLayout.currentIndex = 1
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

    states: [
        State {
            name: "afterSend"

            PropertyChanges {
                target: busyIndicator
                running: true
            }
            PropertyChanges {
                target: sendCoinScreen
                enabled: false
            }
        },
        State {
            name: "beforeSend"

            PropertyChanges {
                target: busyIndicator
                running: false
            }
            PropertyChanges {
                target: sendCoinScreen
                enabled: true
            }
        }
    ]

    function changeBehaviorButton() {
        stackLayout.currentIndex = 0
    }

    function checkingData() {
        if ((1 > receiversAddress.text.length) || (receiversAddress.text.length > 100)) {
            screenDialog.text = qsTr("You entered the wrong account number! Please input correct account number")
            screenDialog.open()
        } else if ((0.0001 > coinsAmountTextField.text) || (coinsAmountTextField.text > 100000.0)) {
            screenDialog.title = qsTr("Input error")
            screenDialog.text = qsTr("The amount must be more than 0 and less than 100 000! Please input correct value")
            screenDialog.open()
        } else {
            GraftClient.transfer(receiversAddress.text, coinsAmountTextField.text)
            sendCoinScreen.state = "afterSend"
        }
    }
}
