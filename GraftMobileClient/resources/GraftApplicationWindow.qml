import QtQuick 2.9
import QtQuick.Controls 2.2

ApplicationWindow {
    id: root

    property bool allowClose: false
    property var handleBackEvent: null

    visible: true
    height: 683
    width: 384
    maximumHeight: 683
    maximumWidth: 384
    minimumHeight: 683
    minimumWidth: 384
    Component.onCompleted: init()

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
