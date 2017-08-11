import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import "../"

ColumnLayout {
    id: rootItem

    signal payButtonClicked()

    property real amountGraft: 0
    property real amountMoney: 0

    spacing: 50

    Image {
        id: graftWalletLogo
        Layout.alignment: Qt.AlignCenter
        Layout.topMargin: 50
        source: "qrc:/imgs/graft_wallet_logo.png"
    }

    ColumnLayout {
        spacing: 20
        Layout.alignment: Qt.AlignCenter

        Text {
            Layout.alignment: Qt.AlignCenter
            font {
                pointSize: 15
                bold: true
            }
            color: "#707070"
            text: qsTr("Balance")
        }

        Text {
            Layout.alignment: Qt.AlignCenter
            font.pointSize: 19
            color: "black"
            text: amountGraft + "g"
        }

        Text {
            Layout.alignment: Qt.AlignCenter
            font {
                pointSize: 15
                bold: true
            }
            color: "#707070"
            text: amountMoney + "USD"
        }
    }

    RoundButton {
        id: payButton
        topPadding: 15
        bottomPadding: 15
        highlighted: true
        Material.elevation: 0
        Material.accent: "#707070"
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignCenter
        Layout.leftMargin: 100
        Layout.rightMargin: 100
        text: qsTr("Pay")
        font {
            family: "Liberation Sans"
            pointSize: 18
            capitalization: Font.MixedCase
        }
        onPressed: rootItem.payButtonClicked()
    }
}
