import QtQuick 2.9
import QtMultimedia 5.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QZXing 2.3

BaseScreen {
    id: root
    signal qrCodeDetected()

    Connections {
        target: client

        onReadyToPayReceived: {
            if(result === true)
            {
                root.openPaymentConfirmationView()
            }
            console.log("AAAAAAAAAAAAAAAAAA")
         }
    }

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
            width: parent.width * 0.75
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
            var rect = Qt.rect(0, 0, 1, 1)
            var normalizedRect = videoOutput.mapNormalizedRectToItem(rect)
            return videoOutput.mapRectToSource(normalizedRect)
        }


        decoder {
            enabledDecoders: QZXing.DecoderFormat_QR_CODE

            onTagFound: {
                console.log(tag + " | " + " | " + decoder.charSet());
                client.readyToPay("%1;%2").arg(tag).arg("dsvsvs")
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
