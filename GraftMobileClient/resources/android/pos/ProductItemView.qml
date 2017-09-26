import QtQuick 2.0
import QtQuick.Layouts 1.3
import "../components"
import "../"

BaseProductItemView {
    ColumnLayout {
        spacing: 0
        anchors {
            fill: parent
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
            Layout.fillHeight: true
            title: qsTr("Item description:")
            wrapMode: TextInput.WordWrap
            maximumLength: 150
        }

        RowLayout {
            id: list
            spacing: 10
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

            TextField {
                id: price
                bottomPadding: 3
                placeholderText: qsTr("Price:")
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignBottom
                Layout.preferredHeight: graftCBox.height
                validator: DoubleValidator {
                    decimals: 3
                    notation: DoubleValidator.StandardNotation
                }
            }

            ColumnLayout {
                spacing: -3
                Layout.fillWidth: true

                ComboBox {
                    id: graftCBox
                    Layout.fillWidth: true
                    Material.background: "#00707070"
                    Material.foreground: "#99757577"
                }

                Rectangle {
                    height: 1
                    color: "#acacac"
                    Layout.fillWidth: true
                }
            }
        }
    }
}
