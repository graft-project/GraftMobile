import QtQuick 2.9
import QtMultimedia 5.9
import QtQuick.Controls 2.2

BaseScreen {
    id: root
    signal qrCodeDetected()

    onVisibleChanged: {
        if (visible) {
            camera.start()
        }
    }

    title: qsTr("Pay")

    Camera {
        id: camera
        focus {
            focusMode: Camera.FocusMacro
            focusPointMode: Camera.FocusPointCustom
            customFocusPoint: Qt.point(0.5, 0.5) // Focus relative to the frame center
        }
    }

    VideoOutput {
        source: camera
        autoOrientation: true
        anchors.fill: parent
        focus: visible
        fillMode: VideoOutput.PreserveAspectCrop
    }

    Timer {
        interval: 1000
        running: true
        onTriggered: {
            camera.stop()
            root.pushScreen()
        }
    }
}
