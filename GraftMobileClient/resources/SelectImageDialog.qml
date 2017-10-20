import QtQuick 2.9
import QtQuick.Controls.Material 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Popup {
    id: popUp
    padding: 0
    modal: true
    focus: true
    width: parent.width / 1.2
    height: botton.height * 2.5
    topMargin: parent.height / 2
    leftMargin: parent.width / 2 - (popUp.width - 30) / 2
    contentItem: ColumnLayout {
        spacing: 0
        anchors.fill: parent

        Button {
            Layout.fillWidth: true
            Material.elevation: 0
            contentItem: RowLayout {
                anchors {
                    fill: parent
                    leftMargin: 15
                    rightMargin: 40
                }

                Image {
                    Layout.preferredHeight: 50
                    Layout.preferredWidth: 50
                    Layout.alignment: Qt.AlignLeft
                    source: "qrc:/test/gallery.png"
                }

                Text {
                    Layout.alignment: Qt.AlignLeft
                    font.pointSize: 20
                    text: qsTr("Open gallary")
                    color: "#3A3E3C"
                }
            }
            onClicked: {
                ImagePicker.openGallary()
                popUp.close()
            }
        }

        Button {
            Layout.fillWidth: true
            Material.elevation: 0
            contentItem: RowLayout {
                id: botton
                anchors {
                    fill: parent
                    leftMargin: 15
                    rightMargin: 40
                }

                Image {
                    Layout.preferredHeight: 50
                    Layout.preferredWidth: 50
                    Layout.alignment: Qt.AlignLeft
                    source: "qrc:/test/camera.png"
                }

                Text {
                    Layout.alignment: Qt.AlignLeft
                    font.pointSize: 20
                    text: qsTr("Open camera")
                    color: "#3A3E3C"
                }
            }
            onClicked: {
                ImagePicker.openCamera()
                popUp.close()
            }
        }
    }
}
