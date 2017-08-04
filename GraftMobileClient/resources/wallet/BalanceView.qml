import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

ApplicationWindow {
    id: balanceView
    visible: true
    width: 640
    height: 480
    title: qsTr("Balance View")

//    header: Rectangle {
//    id: header
//    width: parent.width
//    height: 50
//    color: "grey"

//        Text {
//            id: topText
//            anchors.centerIn: parent
//            text: "Wallet"
//            color: "white"
//        }
//    }

    ColumnLayout {
        id: column
        width: balanceView.width

        Rectangle {
            id: picture
            width: 100
            height: 100
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 40
            color: "red"
        }

        Text {
            text: "Balance"
            color: "grey"
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 40
            font.pointSize: 15
        }

        Text {
            text: "1.2g"
            color: "black"
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 25
            font.pointSize: 19
        }

        Text {
            text: "145USD"
            color: "grey"
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 20
            font.pointSize: 15
        }

        RoundButton {
            id: buttonPay
            text: "Pay"
            Layout.alignment: Qt.AlignCenter
            font.pointSize: 18
        }
    }
}
