import QtQuick 2.0

Rectangle {
    id: header
    width: parent.width
    height: 50
    color: "grey"

        Image {
            id: menuButton
            source: "/imgs/menu_icon.png"
            width: 23
            height: 23
//            Layout.alignment: Qt.AlignCenter
//            Layout.topMargin: 40
        }
        Text {
            id: topText
            anchors.centerIn: parent
            text: "Wallet"
            color: "white"
        }
    }
