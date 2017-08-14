import QtQuick 2.9
import QtMultimedia 5.9
import QtQuick.Controls 2.2

BaseScreen {
    id: root
    signal detectQRCode()

    onVisibleChanged: {
        if (visible) {
            camera.start()
        }
    }

    Camera {
        id: camera
        focus {
            focusMode: Camera.FocusMacro
            focusPointMode: Camera.FocusPointCustom
            customFocusPoint: Qt.point(0.2, 0.2)
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
        interval: 1000;
        running: true;
        repeat: false;
        onTriggered: {
            camera.stop()
            root.pushScreen()
        }
    }
}
