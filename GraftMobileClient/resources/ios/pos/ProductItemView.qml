import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.device.platform 1.0
import "../components"
import "../"

Item {
    property alias currencyText: graftComboBox.currentText
    property alias currencyModel: graftComboBox.currencyModel
    property alias currencyIndex: graftComboBox.currencyIndex
    property alias titleText: title.text
    property alias descriptionText: description.text
    property alias price: price.text
    property alias productImage: previewImage.source
    property alias screenWidth: imageDialog.rootScreenWidth
    property alias screenHeight: imageDialog.rootScreenHeight

    Connections {
        target: Detector.isPlatform(Platform.Desktop) ? null : ImagePicker
        onImageSelected: previewImage.source = path
    }

    SelectImageDialog {
        id: imageDialog
    }

    ColumnLayout {
        spacing: 5
        anchors.fill: parent

        Flickable {
            id: flickable
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.bottomMargin: -14
            ScrollBar.vertical: ScrollBar {
                parent: flickable.parent
                anchors {
                    top: flickable.top
                    bottom: flickable.bottom
                    left: flickable.right
                    right: flickable.right
                    rightMargin: -5
                }
                size: 1.0
            }
            clip: true
            flickableDirection: Flickable.AutoFlickIfNeeded
            contentHeight: productView.height

            ColumnLayout {
                id: productView
                spacing: 5
                anchors {
                    left: parent.left
                    right: parent.right
                }

                LinearEditItem {
                    id: title
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    title: qsTr("Item title:")
                    maximumLength: 50
                }

                LinearEditItem {
                    id: description
                    Layout.fillWidth: true
                    Layout.preferredHeight: 170
                    Layout.alignment: Qt.AlignTop
                    title: qsTr("Item description:")
                    wrapMode: TextInput.WordWrap
                    maximumLength: 150
                }

                RowLayout {
                    spacing: 10

                    LinearEditItem {
                        id: price
                        title: qsTr("Price:")
                        Layout.fillWidth: true
                        Layout.preferredWidth: 50
                        Layout.topMargin: 2
                        Layout.alignment: Qt.AlignTop
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                        showLengthIndicator: false
                        validator: RegExpValidator {
                            regExp: priceRegExp()
                        }
                    }

                    CurrencyComboBox {
                        id: graftComboBox
                        Layout.fillWidth: true
                        Layout.preferredWidth: 50
                        Layout.minimumWidth: 62
                        Layout.alignment: Qt.AlignTop
                        dropdownTitle: qsTr("Currency:")
                    }
                }

                Image {
                    id: previewImage
                    Layout.alignment: Qt.AlignCenter
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.maximumHeight: 250
                    Layout.minimumHeight: 90
                    fillMode: Image.PreserveAspectFit
                    visible: previewImage.status === Image.Ready
                }

                Button {
                    Layout.alignment: Qt.AlignCenter
                    flat: true
                    contentItem: RowLayout {
                        spacing: 10

                        Image {
                            id: addImage
                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 30
                            Layout.alignment: Qt.AlignLeft
                            source: "qrc:/imgs/add_ios.png"
                        }

                        Label {
                            id: buttonText
                            Layout.alignment: Qt.AlignRight
                            color: "#007AFF"
                            text: qsTr("Add photo")
                        }
                    }
                    onClicked: {
                        if (Detector.isPlatform(Platform.IOS)) {
                            imageDialog.openDialog()
                        } else {
                            fileDialog.open()
                        }
                    }
                }

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a picture"
        folder: shortcuts.pictures
        nameFilters: filenameExtension()
        onAccepted: previewImage.source = fileDialog.fileUrls.toString()
    }

    function filenameExtension() {
        var extension = ["BMP (*.bmp *.dib)", "JPEG (*.jpg *.jpeg *.jpe *.jfif)", "PNG (*.png)"]
        return Detector.isPlatform(Platform.MacOS) ?
                    extension.concat("JPEG 2000 (*.jp2 *.jpc)").sort() : extension
    }
}
