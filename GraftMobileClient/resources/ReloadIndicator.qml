import QtQuick 2.9
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0

Pane {
    id: reloadIndicator

    property alias imageRotation: arrow.rotation
    property bool isReloaded: opacity === 1.0

    signal startReload()

    opacity: imageRotation / 270
    width: height
    Material.elevation: 9
    Material.background: "transparent"
    padding: 0

    contentItem: Rectangle {
        radius: height
        color: ColorFactory.color(DesignFactory.Foreground)

        Image {
            id: arrow
            anchors.centerIn: parent
            sourceSize.width: parent.height * 0.55
            sourceSize.height: parent.height * 0.55
            source: "qrc:/imgs/refresh.svg"

            onRotationChanged: {
                if (!isReloaded && rotation >= 270) {
                    startReloading()
                }
            }
        }
    }

    RotationAnimation {
        id: rotationAnimation
        target: arrow
        loops: Animation.Infinite
        duration: 550
        from: 0
        to: 360
    }

    states: [
        State {
            name: "base"
            PropertyChanges {
                target: rotationAnimation
                alwaysRunToEnd: true
                running: false
            }
            PropertyChanges {
                target: reloadIndicator
                opacity: imageRotation / 270
            }
        },
        State {
            name: "pulled"
            PropertyChanges {
                target: rotationAnimation
                alwaysRunToEnd: false
                running: true
            }
            PropertyChanges {
                target: reloadIndicator
                opacity: 1
            }
        }
    ]

    function startReloading() {
        reloadIndicator.state = "pulled"
        startReload()
    }

    function stopReloading() {
        reloadIndicator.state = "base"
    }
}
