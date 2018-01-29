import QtQuick 2.9
import com.graft.design 1.0

Text {
    id: button

    property alias name: button.text
    signal buttonClicked()

    font.pointSize: 17
    color: ColorFactory.color(DesignFactory.LightText)

    OpacityAnimator {
        id: opacityAnimator
        target: button
        from: 1.0
        to: 0.2
        duration: 1000
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: buttonClicked()
        onPressed: opacityAnimator.running = true
        onReleased: button.opacity = 1.0
    }
}
