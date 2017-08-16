import QtQuick 2.9
import QtMultimedia 5.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QZXing 2.3

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
            width: parent.width / 2
            height: width
            anchors.centerIn: parent
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.7
    }

    OpacityMask {
        anchors.fill: parent
        source: videoOutput
        maskSource: captureZone
    }

    QZXingFilter {
        id: zxingFilter
        captureRect: {
            return videoOutput.mapRectToSource(videoOutput.mapNormalizedRectToItem(Qt.rect(
                                                                                       0, 0, 1, 1
                                                                                       )));
        }

        decoder {
            enabledDecoders: QZXing.DecoderFormat_EAN_13 | QZXing.DecoderFormat_QR_CODE

            onTagFound: {
                console.log(tag + " | " + decoder.foundedFormat() + " | " + decoder.charSet());
                lastTag = tag;
            }

            tryHarder: false
        }
    }

    Timer {
        interval: 10000
        running: true
        onTriggered: {
            camera.stop()
            root.pushScreen()
        }
    }
}
