import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Popup {
    id: popUp

    property alias cameraButtonEnabled: openCameraButton.enabled
    property alias dialog: popUp
    property int screenHeight: 0
    property int screenWidth: 0

    padding: 0
    topPadding: 0
    bottomPadding: 0
    modal: true
    focus: true
    width: screenWidth / 1.2
    height: contentHeight
    topMargin: screenHeight / 2
    leftMargin: screenWidth / 2 - (popUp.width - 30) / 2

    ColumnLayout {
        spacing: 0
        anchors.fill: parent

        SelectImageButton {
            selectIcon: "qrc:/imgs/gallery.png"
            selectText: qsTr("Open gallery")
            onClicked: {
                ImagePicker.openGallary()
                popUp.close()
            }
        }

        SelectImageButton {
            id: openCameraButton
            selectIcon: "qrc:/imgs/photo.png"
            selectText: qsTr("Open camera")
            onClicked: {
                ImagePicker.openCamera()
                popUp.close()
            }
        }
    }
}
