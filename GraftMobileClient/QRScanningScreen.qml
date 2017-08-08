import QtQuick 2.0
import QtMultimedia 5.9

Item {

    Camera {
        id: camera
    }

    VideoOutput {
        source: camera
        autoOrientation: true
        anchors.fill: parent
        focus : visible
    }
}
