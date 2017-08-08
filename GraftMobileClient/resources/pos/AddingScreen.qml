import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.2
import QtQuick.Controls.Styles 1.4

Item {
    ColumnLayout {
        y: 62
        anchors.left: parent.left
        anchors.right: parent.right
        height: 418
        spacing: 3
        anchors.rightMargin: 20
        anchors.leftMargin: 20
        anchors.topMargin: 20

        TextField {
            id: title
            placeholderText: "Title: "
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignLeft
            transformOrigin: Item.Center
        }

        RowLayout {
            id: list
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            spacing: 10

            TextField {
                id: price
                bottomPadding: 0
                placeholderText: "Price: "
                Layout.alignment: Qt.AlignBottom
                Layout.fillWidth: true
                Layout.preferredHeight: graftCBox.height
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0
                ComboBox {
                    id: graftCBox

                    Layout.fillWidth: true
                    Material.background: "#00707070"
                    Material.foreground: "#99757577"
                    model: ListModel {
                        ListElement { key: qsTr("Graft")}
                    }
                }
                Rectangle {
                    height: 1
                    Layout.fillHeight: graftCBox.padding
                    Layout.fillWidth: true
                    color: "#919191"
                }
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignCenter
            RoundButton {
                id: addButton
                Layout.preferredHeight: 70
                Layout.preferredWidth: 70
                padding: 20
                highlighted: true
                Material.elevation: 0
                Material.accent: "#d7d7d7"
                contentItem: Image {
                    source: "qrc:/imgs/plus_icon.png"
                }
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "ADD PHOTO"
                color: "#757575"
                font {
                    family: "Liberation Sans Narrow"
                    pixelSize: 15
                }
            }
        }

        RoundButton {
            radius: 14
            topPadding: 15
            bottomPadding: 15
            highlighted: true
            Material.elevation: 0
            Material.accent: "#757575"
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter
            Layout.leftMargin: 40
            Layout.rightMargin: 40
            Layout.bottomMargin: 20
            text: qsTr("Confirm")
            font {
                family: "Liberation Sans Narrow"
                pointSize: 14
                capitalization: Font.MixedCase
            }
        }
    }
}
