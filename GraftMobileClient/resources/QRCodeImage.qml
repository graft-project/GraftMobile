import QtQuick 2.9
import com.device.platform 1.0

Image {
    id: qrCode

    property bool qrCodeSize: false
    property real defaultSize: Detector.isPlatform(Platform.Android) ? 160 : 180

    cache: false
    source: GraftClient.qrCodeImage()
    state: "defaultSize"
    states: [
        State {
            name: "defaultSize"
            when: qrCodeSize

            PropertyChanges {
                target: qrCode
                defaultSize: parent.width - 40
            }
        }
    ]
    transitions: Transition {
        id: transition

        PropertyAnimation {
            easing.type: Easing.InQuad
            property: "defaultSize"
            duration: 500
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (!transition.running) {
                qrCodeSize = !qrCodeSize
            }
        }
    }
}
