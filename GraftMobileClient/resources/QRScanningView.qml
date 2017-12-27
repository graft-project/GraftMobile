import QtQuick 2.9
import QtMultimedia 5.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QZXing 2.3

Item {
    property string lastTag: ""
    property alias cameraReset: camera

    signal qrCodeDetected(string message)

    function reset() {
        camera.start()
        lastTag = ""
    }

    onVisibleChanged: {
        if (visible) {
            camera.start()
        }
    }

    Camera {
        id: camera
        focus {
            focusMode: Camera.FocusContinuous
            focusPointMode: Camera.FocusPointCustom
            customFocusPoint: Qt.point(0.5, 0.5) // Focus relative to the frame center
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
                //                if (lastTag != tag) {
                lastTag = tag
                console.log(tag + " | " + " | " + decoder.charSet())
                camera.stop()
                qrCodeDetected(tag)
                //                }
            }
        }
    }
}
