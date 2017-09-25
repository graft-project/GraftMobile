import QtQuick 2.9
import com.graft.design 1.0
import "../"

Rectangle {
    id: toolBarItem

    signal clicked()
    property alias source: toolButtonIcon.source
    property alias text: toolButtonText.text

    width: 58
    height: 46
    radius: 6
    color: mouseArea.pressed ? "#25FFFFFF" : "transparent"

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: toolBarItem.clicked()
    }

    Image {
        id: toolButtonIcon
        width: 33
        height: toolButtonIcon.width
        anchors.horizontalCenter: toolBarItem.horizontalCenter
    }

    Text {
        id: toolButtonText
        color: ColorFactory.color(DesignFactory.LightText)
        font.pointSize: 10
        anchors {
            top: toolButtonIcon.bottom
            bottom: parent.bottom
            horizontalCenter: toolButtonIcon.horizontalCenter
        }
    }
}
