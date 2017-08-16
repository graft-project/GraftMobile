import QtQuick 2.9
import QtMultimedia 5.9
import QtQuick.Controls 2.2
import QZXing 2.3

BaseScreen {
    id: root
    signal qrCodeDetected()

    property string lastTag: ""

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

        Rectangle {
            id: captureZone
            color: "red"
            opacity: 0.2
            width: parent.width / 2
            height: parent.height / 2
            anchors.centerIn: parent
        }

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

    Text
    {
        id: text2
        wrapMode: Text.Wrap
        font.pixelSize: 20
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        z: 50
        text: "Last tag: " + lastTag
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
