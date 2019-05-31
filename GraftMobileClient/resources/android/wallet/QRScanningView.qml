import QtQuick 2.9
import QtMultimedia 5.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QZXing 2.3
import org.graft 1.0
import "../components"

Item {
    property string lastTag: ""

    signal qrCodeDetected(string message)

    state: "scanScreen"
    onVisibleChanged: {
        if (visible) {
            camera.start()
        } else {
            camera.stop()
        }
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
                    resetView()
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
            Component.onCompleted: setOrientation()
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
        implicitHeight: 150
        implicitWidth: parent.width - 60
        anchors.centerIn: parent
        visible: false

        Label {
            anchors.fill: parent
            wrapMode: Label.WordWrap
            horizontalAlignment: Label.AlignHCenter
            font.pixelSize: 16
            color: "#A8A8A8"
            text: GraftClientConstants.invalidCameraPermissionMessage()
        }

        WideActionButton {
            id: resetButton
            anchors {
                bottom: parent.bottom
                right: parent.right
                left: parent.left
                rightMargin: 100
                leftMargin: 100
            }
            text: qsTr("Reset")
            onClicked: resetView()
        }
    }

    states: [
        State {
            name: "scanScreen"

            PropertyChanges { target: scanScreen; visible: true }
            PropertyChanges { target: messagesScreen; visible: false }
            when: camera.availability === Camera.Available
        },

        State {
            name: "messagesScreen"

            PropertyChanges { target: scanScreen; visible: false }
            PropertyChanges { target: messagesScreen; visible: true }
            when: camera.cameraStatus === 0 && camera.cameraState === 0
        }
    ]

    function resetView() {
        camera.start()
        lastTag = ""
    }

    //TODO: Only for don't write check platforms always where used this method
    function stopScanningView() { }

    function setOrientation() {
        switch (GraftClientTools.cameraOrientation()) {
            case 270: videoOutput.orientation = 90; return
            case 90: videoOutput.orientation = -90; return
            case 180: videoOutput.orientation = 180; return
            case 0: videoOutput.orientation = 0; return
        }
    }
}
