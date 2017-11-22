import QtQuick 2.9
import QtQuick.Controls.Material 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
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

    Connections {
        target: ImagePicker
        onImageSelected: {
            previewImage.source = path
        }
    }

    SelectImageDialog {
        id: popUp
    }

    ColumnLayout {
        spacing: 5
        anchors.fill: parent

        LinearEditItem {
            id: title
            Layout.fillWidth: true
            title: qsTr("Item title:")
            maximumLength: 50
        }

        LinearEditItem {
            id: description
            Layout.fillWidth: true
            Layout.maximumHeight: 150
            Layout.minimumHeight: 120
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
                Layout.alignment: Qt.AlignTop
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                showLengthIndicator: false
                validator: RegExpValidator {
                    regExp: /\d+[.]\d{10}/
                }
            }

            CurrencyComboBox {
                id: graftComboBox
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                Layout.preferredWidth: 130
                dropdownTitle: qsTr("Currency:")
            }
        }

        Image {
            id: previewImage
            Layout.alignment: Qt.AlignCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.maximumHeight: 250
            Layout.minimumHeight: 100
            fillMode: Image.PreserveAspectFit
            source: ""
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

                Text {
                    id: buttonText
                    Layout.alignment: Qt.AlignRight
                    text: qsTr("Add photo")
                    color: "#007AFF"
                }
            }
            onClicked: popUp.open()
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
