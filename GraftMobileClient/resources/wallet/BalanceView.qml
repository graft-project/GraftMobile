import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import "../"
import "../components"

BaseScreen {
    id: rootItem

    property real amountGraft: 0
    property real amountMoney: 0

    title: qsTr("Wallet")

    ColumnLayout {

        anchors.fill: parent
        spacing: 30

        Image {
            id: graftWalletLogo
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 50
            Layout.preferredHeight: parent.width / 2
            Layout.preferredWidth: parent.width / 2
            fillMode: Image.PreserveAspectFit
            source: "qrc:/imgs/graft_wallet_logo.png"
        }

        ColumnLayout {
            spacing: 20
            Layout.alignment: Qt.AlignCenter

            Text {
                Layout.alignment: Qt.AlignCenter
                font {
                    pointSize: 16
                    bold: true
                }
                color: "#707070"
                text: qsTr("Balance")
            }

            RowLayout {
                spacing: 0
                Layout.alignment: Qt.AlignCenter

                Text {
                    font.pointSize: 20
                    color: "black"
                    text: amountGraft
                }

                Image {
                    Layout.preferredHeight: 25
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/imgs/g_icon_black.png"
                }
            }

            Text {
                Layout.alignment: Qt.AlignCenter
                font {
                    pointSize: 16
                    bold: true
                }
                color: "#707070"
                text: amountMoney + "USD"
            }
        }

        WideRoundButton {
            text: qsTr("PAY")
            onPressed: {
                pushScreen.openQRCodeScanner()
            }
        }
    }
}
