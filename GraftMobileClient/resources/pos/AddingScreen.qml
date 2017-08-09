import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

Item {
    property alias currencyModel: graftCBox.model

    ColumnLayout {
        spacing: 3
        anchors {
            top: parent.top
            topMargin: 55
            bottom: parent.bottom
            bottomMargin: 20
            left: parent.left
            leftMargin: 20
            right: parent.right
            rightMargin: 20
        }

        TextField {
            id: title
            Layout.fillWidth: true
            placeholderText: "Title: "
        }

        RowLayout {
            id: list
            spacing: 10
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

            TextField {
                id: price
                bottomPadding: 3
                placeholderText: "Price: "
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignBottom
                Layout.preferredHeight: graftCBox.height
                validator: IntValidator {}
            }

            ColumnLayout {
                spacing: -5
                Layout.fillWidth: true

                ComboBox {
                    id: graftCBox
                    Layout.fillWidth: true
                    Material.background: "#00707070"
                    Material.foreground: "#99757577"
                }

                Rectangle {
                    height: 1
                    color: "#919191"
                    Layout.fillWidth: true
                }
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignCenter

            RoundButton {
                id: addButton
                padding: 25
                Layout.preferredHeight: 80
                Layout.preferredWidth: 80
                highlighted: true
                Material.elevation: 0
                Material.accent: "#d7d7d7"
                contentItem: Image {
                    source: "qrc:/imgs/plus_icon.png"
                }
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("ADD PHOTO")
                color: "#757575"
                font {
                    family: "Liberation Sans"
                    pointSize: 10
                }
            }
        }

        RoundButton {
            radius: 14
            topPadding: 13
            bottomPadding: 13
            highlighted: true
            Material.elevation: 0
            Material.accent: "#757575"
            Layout.alignment: Qt.AlignCenter
            Layout.fillWidth: true
            Layout.leftMargin: 40
            Layout.rightMargin: 40
            Layout.bottomMargin: 20
            text: qsTr("Confirm")
            font {
                family: "Liberation Sans"
                pointSize: 13
                capitalization: Font.MixedCase
            }
        }
    }
}
