import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../"

Item {
    id: balanceView

    ColumnLayout {
        id: column
        width: balanceView.width

        Image {
            id: graftWalletLogo
            source: "/imgs/graft_wallet_logo.png"
            width: 200
            height: 200
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 40
        }

        Text {
            text: "Balance"
            color: "grey"
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 50
            font.pointSize: 15
        }

        Text {
            text: "1.2g"
            color: "black"
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 20
            font.pointSize: 19
        }

        Text {
            text: "145USD"
            color: "grey"
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 15
            Layout.bottomMargin: 50
            font.pointSize: 15
        }

        RoundButton {
            id: buttonPay
            text: "Pay"
            Layout.alignment: Qt.AlignCenter
            font.pointSize: 18
            Layout.preferredWidth: parent.width * 3 / 4
        }
    }
}
