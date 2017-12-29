import QtQuick 2.9
import QtQuick.Layouts 1.3
import "components"

BaseScreen {
    id: balance

    property string balanceState: "mainAddress"
    property alias accountName: coinAccountDelegate.accountTitle
    property alias accountImage: coinAccountDelegate.productImage
    property alias accountBalance: coinAccountDelegate.accountBalance
    property string accountNumber: ""
    property string accountType: ""

    state: balanceState
    screenHeader {
        navigationButtonState: Qt.platform.os === "ios"
    }

    Component.onCompleted: {
        if (Qt.platform.os === "ios") {
            navigationText: qsTr("Cancel")
            background.color = "#ffffff"
        }
    }

    ColumnLayout {
        spacing: 0
        anchors.fill: parent

        BalanceViewItem {
            id: mainBalance
            visible: false
            Layout.fillWidth: true
        }

        CoinAccountDelegate {
            id: coinAccountDelegate
            visible: false
            Layout.fillWidth: true
            Layout.topMargin: 10
            Layout.bottomMargin: 10
            topLineVisible: false
            bottomLineVisible: false
        }

        Rectangle {
            id: background
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#e9e9e9"

            Image {
                id: qrCodeImage
                cache: false
                height: 230
                width: height
                anchors {
                    centerIn: parent
                    margins: 10
                }
            }
        }

        Rectangle {
            color: "#ffffff"
            Layout.fillWidth: true
            Layout.preferredHeight: 180

            ColumnLayout {
                spacing: 0
                anchors {
                    fill: parent
                    margins: 15
                }

                Text {
                    id: address
                    Layout.fillWidth: true
                    Layout.leftMargin: 20
                    Layout.rightMargin: 20
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WrapAnywhere
                    color: "#010101"
                    font {
                        bold: true
                        pointSize: 16
                    }
                }

                WideActionButton {
                    id: clipboardButton
                    Layout.fillWidth: true
                    text: qsTr("Copy to clipboard")
                    Layout.alignment: Qt.AlignBottom
                }
            }
        }
    }

    states: [
        State {
            name: "mainAddress"
            PropertyChanges {
                target: balance
                title: qsTr("Main Account")
            }
            PropertyChanges {
                target: mainBalance
                visible: true
                balanceVisible: false
            }
            PropertyChanges {
                target: coinAccountDelegate
                visible: false
            }
            PropertyChanges {
                target: address
                text: GraftClient.address()
            }
            PropertyChanges {
                target: qrCodeImage
                source: GraftClient.addressQRCodeImage()
            }
            PropertyChanges {
                target: clipboardButton
                onClicked: GraftClient.copyWalletNumber(GraftClient.address())
            }
        },

        State {
            name: "coinsAddress"
            PropertyChanges {
                target: balance
                title: qsTr("%1 Account").arg(accountType)
            }
            PropertyChanges {
                target: mainBalance
                visible: false
            }
            PropertyChanges {
                target: coinAccountDelegate
                coinVisible: false
                visible: true
            }
            PropertyChanges {
                target: address
                text: accountNumber
            }
            PropertyChanges {
                target: qrCodeImage
                source: GraftClient.coinAddressQRCodeImage(accountNumber)
            }
            PropertyChanges {
                target: clipboardButton
                onClicked: GraftClient.copyWalletNumber(accountNumber)
            }
        }
    ]
}
