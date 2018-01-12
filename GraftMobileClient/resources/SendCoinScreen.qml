import QtQuick 2.9
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import "components"

BaseScreen {
    id: sendCoinScreen

    title: qsTr("Send Coins")
    screenHeader.actionButtonState: true

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
                        Layout.maximumHeight: 150
                        maximumLength: 100
                        wrapMode: TextField.WrapAnywhere
                        title: Qt.platform.os === "ios" ? qsTr("Receivers address:") : qsTr("Receivers address")
                    }

                    LinearEditItem {
                        id: coinsAmountTextField
                        Layout.fillWidth: true
                        title: Qt.platform.os === "ios" ? qsTr("Amount:") : qsTr("Amount")
                        showLengthIndicator: false
                        inputMethodHints: Qt.ImhDigitsOnly
                        validator: DoubleValidator {
                            bottom: 0.0001
                            top: 100000.0
                        }
                    }

                    Label {
                        anchors {
                            right: coinsAmountTextField.right
                            verticalCenter: coinsAmountTextField.verticalCenter
                            verticalCenterOffset: 3
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

    function changeBehaviorButton() {
        stackLayout.currentIndex = 0
    }
}
