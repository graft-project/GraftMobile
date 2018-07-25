import QtQuick 2.9
import QtQuick.Controls 2.2
import com.graft.design 1.0
import com.device.platform 1.0
import "../"

Rectangle {
    id: toolBarButton

    property alias source: toolButtonIcon.source
    property alias text: toolButtonText.text
    property alias buttonColor: toolBarButton.color

    signal clicked()

    width: 58
    height: 46
    radius: 6
    color: "transparent"

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: parent.clicked()
    }

    Image {
        id: toolButtonIcon
        width: 33
        height: width
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Label {
        id: toolButtonText
        anchors {
            top: toolButtonIcon.bottom
            bottom: parent.bottom
            horizontalCenter: toolButtonIcon.horizontalCenter
        }
        color: ColorFactory.color(DesignFactory.LightText)
        font.pixelSize: Detector.isDesktop() ? 12 : 10
    }
}
