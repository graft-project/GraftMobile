import QtQuick 2.9
import QtMultimedia 5.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QZXing 2.3

Item {
    property string lastTag: ""

    signal qrCodeDetected(string message)

    onVisibleChanged: {
        if (visible) {
            camera.start()
        } else {
            camera.stop()
        }
    }

    Component.onCompleted: {
        state = camera.cameraStatus === Camera.ActiveStatus ||
                camera.cameraState === Camera.UnloadedState ? "messageScreen" : "scanScreen"
    }

    Item {
        id: scanScreen
        anchors.fill: parent
        visible: false

        Camera {
            id: camera
            focus {
                focusMode: Camera.FocusContinuous
                focusPointMode: Camera.FocusPointCustom
                customFocusPoint: Qt.point(0.5, 0.5) // Focus relative to the frame center
            }
            onCameraStateChanged: {
                if (cameraState === Camera.UnloadedState) {
                    camera.start()
                }
            }
        }

        VideoOutput {
            id: videoOutput
            anchors.fill: parent
            source: camera
            autoOrientation: true
            focus: visible
            fillMode: VideoOutput.PreserveAspectCrop
            filters: [ zxingFilter ]
        }

        Rectangle {
            anchors.fill: parent
            id: captureZone
            color: "transparent"

            Rectangle {
                width: parent.width * 0.75
                height: width
                anchors.centerIn: parent
                color: "green"
                opacity: 0.7
            }
        }

        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: 0.5
        }

        OpacityMask {
            anchors.fill: parent
            source: videoOutput
            maskSource: captureZone
        }

        QZXingFilter {
            id: zxingFilter
            captureRect: {
                var rect = Qt.rect(0, 0, 1, 1)
                var normalizedRect = videoOutput.mapNormalizedRectToItem(rect)
                return videoOutput.mapRectToSource(normalizedRect)
            }

            decoder {
                enabledDecoders: QZXing.DecoderFormat_QR_CODE
                tryHarder: false
                onTagFound: {
                    if (lastTag != tag) {
                        lastTag = tag
                        console.log(tag + " | " + " | " + decoder.charSet())
                        camera.stop()
                        qrCodeDetected(tag)
                    }
                }
            }
        }
    }

    Item {
        id: messageScreen
        implicitHeight: 110
        implicitWidth: parent.width - 60
        anchors.centerIn: parent
        visible: false

        Label {
            anchors.fill: parent
            wrapMode: Label.WordWrap
            horizontalAlignment: Label.AlignHCenter
            font.pixelSize: 16
            color: "#A8A8A8"
            text: qsTr("You haven't permission for the camera. Please, turn on camera permission " +
                       "in settings of the application.")
        }
    }

    states: [
        State {
            name: "scanScreen"
            PropertyChanges { target: scanScreen; visible: true }
            PropertyChanges { target: messageScreen; visible: false }
        },

        State {
            name: "messageScreen"
            PropertyChanges { target: scanScreen; visible: false }
            PropertyChanges { target: messageScreen; visible: true }
        }
    ]

    function resetView() {
        camera.start()
        lastTag = ""
    }
}
