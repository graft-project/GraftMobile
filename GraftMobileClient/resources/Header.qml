import QtQuick 2.0
import QtQuick.Layouts 1.3

Rectangle {
    id: header
    width: parent.width
    height: 60
    color: "grey"

    property alias leftIcon: menuIcon
    property alias headerText: topText
    property alias rightIcon: cartIcon

    RowLayout {
        anchors.fill: parent
        Layout.topMargin: 10

        Image{
            id: menuIcon
            //source: "/imgs/menu_icon.png"
            Layout.preferredWidth: 18
            Layout.preferredHeight: 18
            anchors.left: parent.left
        }

        Text {
            id: topText
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: 15
            //text: "Wallet"
        }

        Image {
            id: cartIcon
            //source: "/imgs/cart_icon.png"
            Layout.preferredWidth: 20
            Layout.preferredHeight: 20
            anchors.right: parent.right
            anchors.rightMargin: 15
        }
    }
}
