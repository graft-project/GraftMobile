import QtQuick 2.9
import QtQuick.Controls 2.2

Rectangle {
    id: temporaryLabel

    property alias labelText: messageLabel.text
    property alias opacityAnimator: opacityAnimator
    property alias timer: timer

    height: messageLabel.height + 20
    width: messageLabel.width + 20
    radius: height
    color: "#353535"
    opacity: 0.0
    z: 1

    Label {
        id: messageLabel
        anchors.centerIn: parent
        color: "#FFFFFF"
        font.pointSize: 16
        horizontalAlignment: Text.AlignHCenter
    }

    OpacityAnimator {
        id: opacityAnimator
        target: temporaryLabel
        from: 1.0
        to: 0.0
        duration: 1000
    }

    Timer {
        id: timer
        interval: 4000
        onTriggered: opacityAnimator.running = true
    }
}
