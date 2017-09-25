import QtQuick 2.9
import com.graft.design 1.0
import "../"

Rectangle {
    id: toolBarItem

    signal clicked()
    property alias source: toolButtonIcon.source
    property alias text: toolButtonText.text

    width: 50
    height: 40
    radius: 6
    color: mouseArea.pressed ? "#25FFFFFF" : "transparent"

    MouseArea {
        id: mouseArea
        anchors.fill: toolBarItem
        onClicked: toolBarItem.clicked()
    }

    Image {
        id: toolButtonIcon
        width: 25
        height: 25
        anchors {
            top: parent.top
            topMargin: 2
            horizontalCenter: toolBarItem.horizontalCenter
        }
    }

    Text {
        id: toolButtonText
        color: ColorFactory.color(DesignFactory.LightText)
        anchors {
            bottom: parent.bottom
            bottomMargin: 13
            verticalCenter: toolButtonIcon.bottom
            horizontalCenter: toolButtonIcon.horizontalCenter
        }
    }
}
