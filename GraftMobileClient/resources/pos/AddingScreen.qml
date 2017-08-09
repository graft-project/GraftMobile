import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.2
import QtQuick.Controls.Styles 1.4

Item {
    ColumnLayout {
        spacing: 3
        anchors.top: parent.top
        anchors.topMargin: 55
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20

        TextField {
            id: title
            placeholderText: "Title: "
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            horizontalAlignment: Text.AlignLeft
            transformOrigin: Item.Center
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
                validator: IntValidator {}
                Layout.preferredHeight: graftCBox.height
            }

            ColumnLayout {
                spacing: -5
                Layout.fillWidth: true

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
                text: "ADD PHOTO"
                color: "#757575"
                font {
                    family: "Liberation Sans Narrow"
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
                family: "Liberation Sans Narrow"
                pointSize: 13
                capitalization: Font.MixedCase
            }
        }
    }
}
