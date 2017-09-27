import QtQuick 2.9
import QtQuick.Controls.Material 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../components"
import "../"

BaseProductItemView {
    property alias currencyModel: graftCBox.model

    ColumnLayout {
        spacing: 5
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }

        LinearEditItem {
            id: title
            Layout.fillWidth: true
            title: qsTr("Item title:")
            maximumLength: 50
        }

        LinearEditItem {
            id: description
            Layout.fillWidth: true
            Layout.preferredHeight: 180
            title: qsTr("Item description:")
            wrapMode: TextInput.WordWrap
            maximumLength: 150
        }

        RowLayout {
            spacing: 10
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

            LinearEditItem {
                id: price
                title: qsTr("Price:")
//                Layout.fillWidth: true
                Layout.preferredHeight: graftCBox.height
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                showLengthIndicator: false
                validator: DoubleValidator {
                    decimals: 3
                    notation: DoubleValidator.StandardNotation
                }
            }

            ColumnLayout {
                spacing: 0
                Layout.fillWidth: true
                Layout.preferredWidth: 130

                ComboBox {
                    id: graftCBox
                    Layout.fillWidth: true
                    Material.background: "#00707070"
                    Material.foreground: "#99757577"
                    leftPadding: dropdownTitle.width -8
                    Layout.topMargin: -8
                    Layout.bottomMargin: -2

                    Text {
                        id: dropdownTitle
                        anchors {
                            top: parent.top
                            left: parent.left
                            topMargin: 13
                        }
                        font.pointSize: parent.font.pointSize
                        color: "#8e8e93"
                        text: qsTr("Currency:")
                    }
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
            Layout.preferredHeight: 100
            fillMode: Image.PreserveAspectFit
            visible: false
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

            onClicked: previewImage.visible = !previewImage.visible
        }
    }
}
