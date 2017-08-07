import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../"

ColumnLayout {
    property string gText
    property string moneyText
    property int countG: 0
    property int countMoney: 0

    spacing: 50
    Layout.fillWidth: true

    Image {
        id: graftWalletLogo
        Layout.alignment: Qt.AlignCenter
        Layout.topMargin: 50
        width: 150
        height: 150
        source: "/imgs/graft_wallet_logo.png"
    }

    ColumnLayout {
        spacing: 20
        Layout.alignment: Qt.AlignCenter

        Text {
            Layout.alignment: Qt.AlignCenter
            font.pointSize: 15
            font.bold: true
            color: "grey"
            text: "Balance"
        }

        Text {
            Layout.alignment: Qt.AlignCenter
            font.pointSize: 19
            color: "black"
            text: gText = countG + "g"
        }

        Text {
            Layout.alignment: Qt.AlignCenter
            font.pointSize: 15
            color: "grey"
            text: moneyText = countMoney + "USD"
        }
    }

    RoundButton {
        id: buttonPay
        Layout.alignment: Qt.AlignCenter
        Layout.preferredWidth: parent.width * 0.75
        font.pointSize: 18
        text: "Pay"
    }
}
