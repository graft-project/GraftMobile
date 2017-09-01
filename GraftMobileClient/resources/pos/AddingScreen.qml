import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import "../components"
import "../"

BaseScreen {
    id: additionItem
    title: qsTr("Add")
    isMenuState: false

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
            placeholderText: qsTr("Title: ")
        }

        RowLayout {
            id: list
            spacing: 10
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

            TextField {
                id: price
                bottomPadding: 3
                placeholderText: qsTr("Price: ")
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignBottom
                Layout.preferredHeight: graftCBox.height
                validator: DoubleValidator {
                    decimals: 3
                    notation: DoubleValidator.StandardNotation
                }
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
                Layout.alignment: Qt.AlignHCenter
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

        WideRoundButton {
            text: qsTr("Confirm")
            onClicked: {
                ProductModel.add("qrc:/imgs/icon-placeholder.png", title.text,
                                 parseFloat(price.text), graftCBox.currentText)
                additionItem.pushScreen.backProductScreen()
                GraftClient.save()
            }
        }
    }
}
