import QtQuick 2.9
import QtQuick.Controls 2.2

ApplicationWindow {
    id: root

    property bool allowClose: false
    property var handleBackEvent: null

    visible: true
    width: 320
    height: 480

    Shortcut {
        sequences: ["Esc", "Back"]
        onActivated: handleBackEvent()
    }

    PopupMessageLabel {
        id: closeLabel
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: 60
            rightMargin: 60
            bottomMargin: 35
        }
        labelText: qsTr("Please, click again to close \nthe application.")
        opacityAnimator.onStopped: allowClose = false
    }

    Component.onCompleted: init()

    function init() {
        if (Qt.platform.os === "ios") {
            root.visibility = ApplicationWindow.FullScreen
        }
    }

    function showCloseLabel() {
        closeLabel.opacity = 1.0
        closeLabel.timer.start()
    }
}
