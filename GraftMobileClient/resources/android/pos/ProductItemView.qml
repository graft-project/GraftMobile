import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
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
        target: ImagePicker
        onImageSelected: previewImage.source = path
    }

    SelectImageDialog {
        id: imageDialog
    }

    ColumnLayout {
        id: mainLayout
        spacing: 5
        anchors.fill: parent

        LinearEditItem {
            id: title
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            title: qsTr("Item title")
            maximumLength: 50
        }

        LinearEditItem {
            id: description
            Layout.fillWidth: true
            Layout.preferredHeight: 140
            Layout.alignment: Qt.AlignTop
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
                Layout.preferredWidth: 70
                Layout.preferredHeight: 40
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
                Layout.preferredWidth: 30
                Layout.preferredHeight: 40
                Layout.alignment: Qt.AlignTop
                dropdownTitle: qsTr("Currency")
            }
        }

        Image {
            id: previewImage
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 12
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.maximumHeight: 250
            Layout.minimumHeight: 90
            fillMode: Image.PreserveAspectFit
            visible: previewImage.status === Image.Ready
        }

        Button {
            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true
            Material.elevation: 0
            Material.background: "#EAF6EF"
            padding: 32
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

                    Label {
                        id: buttonText
                        Layout.alignment: Qt.AlignRight
                        color: "#3A3E3C"
                        font.pixelSize: 14
                        text: previewImage.visible ? qsTr("Change Photo") : qsTr("Add Photo")
                    }
                }
            }
            onClicked: imageDialog.openDialog()
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }
}
