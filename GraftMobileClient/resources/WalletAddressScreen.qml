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
            lockedArrowVisible: false
            unlockedArrowVisible: false
            lockedBalanceButton: true
            unlockedBalanceButton: true
        }

        CoinAccountDelegate {
            id: coinAccountDelegate
            visible: false
            Layout.fillWidth: true
            Layout.margins: 10
            coinClicked: false
            arrowVisible: false
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
                height: 160
                width: height
                anchors {
                    centerIn: parent
                    margins: 20
                }
            }
        }

        Rectangle {
            color: "#ffffff"
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
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
                lockedBalanceButton: false
                unlockedBalanceButton: false
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
        }
    ]
}
