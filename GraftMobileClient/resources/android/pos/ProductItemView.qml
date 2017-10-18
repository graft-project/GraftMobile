import QtQuick 2.9
import QtQuick.Controls.Material 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../components"
import "../"

Item {
    id: a
    readonly property alias currencyText: graftCBox.currentText
    property alias currencyModel: graftCBox.model
    property alias currencyIndex: graftCBox.currentIndex
    property alias titleText: title.text
    property alias descriptionText: description.text
    property alias price: price.text
    property alias productImage: previewImage.source

    Connections {
        target: ImagePicker
        onImageSelected: {
            previewImage.source = path
        }
    }

    Popup {
        id: popUp
        width: 320
        height: 200
        padding: 0
        leftPadding: 0
        rightPadding: 0
        topMargin: a.height / 2
        leftMargin: a.width / 2
        rightMargin: a.width / 2
        modal: true
        focus: true
        contentItem: ColumnLayout {
            anchors.fill: parent
            spacing: 0

//            Button {
//                Layout.fillWidth: true
//                Layout.fillHeight: true
//                Material.elevation: 0
//                contentItem: RowLayout {
//                        spacing: 0
//                        anchors.fill: parent
//                        anchors.leftMargin: 10
//                        anchors.rightMargin: 40

//                        Image {
//                            Layout.preferredHeight: 50
//                            Layout.preferredWidth: 50
//                            Layout.alignment: Qt.AlignLeft
//                            source: "qrc:/test/gallery.png"
//                        }

//                        Text {
//                            Layout.alignment: Qt.AlignLeft
//                            font.pointSize: 20
//                            text: qsTr("Open gallary")
//                            color: "#3A3E3C"
//                        }
//                }
//                onClicked: ImagePicker.openGallary()
//            }

//            Button {
//                Layout.fillWidth: true
//                Layout.fillHeight: true
//                Material.elevation: 0
//                contentItem: Item {
//                    anchors.fill: parent

//                    RowLayout {
//                        spacing: 0
//                        anchors.fill: parent
//                        anchors.leftMargin: 10
//                        anchors.rightMargin: 40

//                        Image {
//                            Layout.preferredHeight: 50
//                            Layout.preferredWidth: 50
//                            Layout.alignment: Qt.AlignLeft
//                            source: "qrc:/test/camera.png"
//                        }

//                        Text {
//                            Layout.alignment: Qt.AlignLeft
//                            font.pointSize: 20
//                            text: qsTr("Open camera")
//                            color: "#3A3E3C"
//                        }
//                    }
//                }
//                onClicked: ImagePicker.openCamera()
//            }
        }
    }

    ColumnLayout {
        id: mainLayout
        spacing: 5
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }

        LinearEditItem {
            id: title
            Layout.fillWidth: true
            title: qsTr("Item title")
            maximumLength: 50
        }

        LinearEditItem {
            id: description
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            title: qsTr("Item description")
            wrapMode: TextInput.WordWrap
            maximumLength: 120
        }

        RowLayout {
            spacing: 10

            LinearEditItem {
                id: price
                title: qsTr("Price")
                Layout.fillWidth: true
                Layout.preferredHeight: graftCBox.height
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                showLengthIndicator: false
                validator: RegExpValidator {
                    regExp: /\d+[.]\d{10}/
                }
            }

            ColumnLayout {
                spacing: 4
                Layout.preferredWidth: 50

                Text {
                    id: dropdownTitle
                    Layout.fillWidth: true
                    color: "#BBBBBB"
                    font.pointSize: 12
                    text: qsTr("Currency")
                }

                ComboBox {
                    id: graftCBox
                    Layout.fillWidth: true
                    Material.background: "#00707070"
                    Material.foreground: "#585858"
                    leftPadding: -12
                    Layout.topMargin: -12
                    Layout.bottomMargin: -10
                    textRole: "name"
                }

                Rectangle {
                    height: 1
                    color: "#acacac"
                    Layout.fillWidth: true
                }
            }
        }

        Image {
            id: previewImage
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 5
            Layout.preferredHeight: 150
            Layout.preferredWidth: 150
            fillMode: Image.PreserveAspectFit
            visible: previewImage.status === Image.Ready
        }

        Button {
            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true
            Material.elevation: 0
            Material.background: "#EAF6EF"
            padding: 35
            contentItem: Item {
                RowLayout {
                    spacing: 10
                    anchors.centerIn: parent

                    Image {
                        id: addImage
                        Layout.preferredHeight: 40
                        Layout.preferredWidth: 40
                        Layout.alignment: Qt.AlignLeft
                        source: "qrc:/imgs/add.png"
                    }

                    Text {
                        id: buttonText
                        Layout.alignment: Qt.AlignRight
                        font.pointSize: 14
                        text: previewImage.visible ? qsTr("Change Photo") : qsTr("Add Photo")
                        color: "#3A3E3C"
                    }
                }
            }

            onClicked: {
                popUp.open()
                //                previewImage.visible = !previewImage.visible
            }
        }
    }
}
