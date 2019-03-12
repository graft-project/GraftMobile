import QtQuick 2.9
import QtQuick.Controls 2.2

RoundButton {
    property alias image: buttonImage

    flat: true
    background: Rectangle {
        anchors.centerIn: parent
        height: parent.height - 10
        width: parent.width - 10
        radius: parent.radius
        color: hovered || pressed ? "#10000000" : "transparent"

        Image {
            id: buttonImage
            anchors.centerIn: parent
        }
    }
}
