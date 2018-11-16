import QtQuick 2.9
import QtMultimedia 5.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QZXing 2.3
import com.device.platform 1.0

Item {
    property string lastTag: ""

    signal qrCodeDetected(string message)

    state: "messagesScreen"
    onVisibleChanged: {
        if (visible) {
            camera.start()
        } else {
            camera.stop()
        }
    }

    Connections {
        target: Detector.isPlatform(Platform.Desktop) ? null : IOSCameraPermission
        onHasCameraPermission: state = "scanScreen"
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
                    if (lastTag !== tag) {
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
        id: messagesScreen
        implicitHeight: 110
        implicitWidth: parent.width - 60
        anchors.centerIn: parent
        visible: false

        Label {
            anchors.fill: parent
            wrapMode: Label.WordWrap
            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
            font.pixelSize: 16
            color: "#A8A8A8"
            text: QtMultimedia.availableCameras.length > 0 ? qsTr("You haven't permission " +
                  "for the camera. Please, turn on camera permission in settings of the " +
                  "application.") : qsTr("The application can't find camera on this device. To " +
                  "use QR-code scanning option, please, connect camera to your device.")
        }
    }

    states: [
        State {
            name: "scanScreen"
            PropertyChanges { target: scanScreen; visible: true }
            PropertyChanges { target: messagesScreen; visible: false }
            when: scanning()
        },

        State {
            name: "messagesScreen"
            PropertyChanges { target: scanScreen; visible: false }
            PropertyChanges { target: messagesScreen; visible: true }
        }
    ]

    function scanning() {
        if (Detector.isDesktop()) {
            return QtMultimedia.availableCameras.length > 0
        }
        return IOSCameraPermission.hasPermission()
    }

    function stopScanningView() {
        if (!Detector.isPlatform(Platform.Desktop)) {
            IOSCameraPermission.stopTimer()
        }
    }

    function resetView() {
        camera.start()
        lastTag = ""
    }
}
