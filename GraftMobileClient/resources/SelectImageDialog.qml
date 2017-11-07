import QtQuick 2.9
import QtQuick.Controls.Material 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Popup {
    id: popUp
    padding: 0
    topPadding: 0
    bottomPadding: 0
    modal: true
    focus: true
    width: parent.width / 1.2
    height: contentHeight
    topMargin: parent.height / 2
    leftMargin: parent.width / 2 - (popUp.width - 30) / 2

    ColumnLayout {
        spacing: 0
        anchors.fill: parent

        SelectImageButton {
            selectIcon: "qrc:/imgs/gallery.png"
            selectText: qsTr("Open gallary")
            onClicked: {
                ImagePicker.openGallary()
                popUp.close()
            }
        }

        SelectImageButton {
            selectIcon: "qrc:/imgs/photo.png"
            selectText: qsTr("Open camera")
            onClicked: {
                ImagePicker.openCamera()
                popUp.close()
            }
        }
    }
}
