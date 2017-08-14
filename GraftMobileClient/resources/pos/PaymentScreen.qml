import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import "../"

ColumnLayout {
    property int price

    RowLayout {
        Layout.topMargin: 20
        Layout.leftMargin: 15
        Layout.rightMargin: 15
        Layout.bottomMargin: 15
        Layout.preferredWidth: parent.width
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

        ColumnLayout {
            id: totalCost
            spacing: 11
            Layout.alignment: Qt.AlignLeft

            Text {
                id: firstTitle
                text: qsTr("Total: ")
                color: "#757575"
                font {
                    family: "Liberation Sans"
                    pointSize: 12
                }
            }

            Text {
                id: cost
                text: qsTr("$ %1").arg(price)
                color: "#757575"
                font {
                    bold: true
                    family: "Liberation Sans"
                    pointSize: 14
                }
            }

            Text {
                id: secondTitle
                text: qsTr("Scan with wallet")
                color: "#757575"
                font {
                    family: "Liberation Sans"
                    pointSize: 12
                }
            }
        }

        Image {
            id: qRCodePicture
            source: "qrc:/examples/QRCode_images.png"
            Layout.alignment: Qt.AlignRight
            Layout.preferredHeight: totalCost.height
            Layout.preferredWidth: totalCost.height
        }
    }

    Rectangle {
        color: "#d7d7d7"
        Layout.preferredHeight: 1.6
        Layout.alignment: Qt.AlignBottom
        Layout.fillWidth: true
    }

    ListModel {
        id: selectedProduct

        ListElement {
            name: "Hairout 1"
            cost: 20
        }

        ListElement {
            name: "Hairout 2"
            cost: 20
        }

        ListElement {
            name: "Hairout 3"
            cost: 20
        }

        ListElement {
            name: "Hairout 4"
            cost: 20
        }

        ListElement {
            name: "Hairout 5"
            cost: 20
        }
    }

    ListView {
        id: viewProduct
        clip: true
        model: selectedProduct
        enabled: !confirmation.visible
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.leftMargin: 15
        Layout.rightMargin: 15
        Layout.topMargin: 9
        Layout.bottomMargin: 9
        delegate: SelectedProductDelegate {
            width: viewProduct.width
            productName: name
            price: cost
        }

        Timer {
            interval: 100
            running: true
            onTriggered: {
                control.visible = true
                bottomCancel.visible = true
            }
        }

        BusyIndicator {
            id: control
            visible: false
            anchors.centerIn: parent
        }

        Timer {
            interval: 4000
            running: true
            onTriggered: {
                confirmation.visible = true
                bottomOk.visible = true
                bottomCancel.visible = false
            }
        }

        Rectangle {
            id: confirmation
            visible: false
            color: "#99ffffff"
            anchors.fill: parent

            ColumnLayout {
                spacing: 12
                anchors.centerIn: parent

                Image {
                    source: "qrc:/imgs/paid_icon.png"
                    Layout.preferredHeight: 100
                    Layout.preferredWidth: 100
                }

                Text {
                    text: qsTr("PAID !")
                    color: "#757575"
                    Layout.alignment: Qt.AlignHCenter
                    font {
                        bold: true
                        family: "Liberation Sans"
                        pointSize: 14
                    }
                }
            }
        }
    }

    RoundButton {
        id: bottomCancel
        visible: false
        radius: 14
        topPadding: 10
        bottomPadding: 10
        highlighted: true
        Material.elevation: 0
        Material.accent: "#757575"
        Layout.alignment: Qt.AlignCenter
        Layout.fillWidth: true
        Layout.leftMargin: 40
        Layout.rightMargin: 40
        Layout.bottomMargin: 10
        text: qsTr("Cancel")
        font {
            family: "Liberation Sans"
            pointSize: 13
            capitalization: Font.MixedCase
        }
    }

    RoundButton {
        id: bottomOk
        visible: false
        radius: 14
        topPadding: 10
        bottomPadding: 10
        highlighted: true
        Material.elevation: 0
        Material.accent: "#757575"
        Layout.alignment: Qt.AlignCenter
        Layout.fillWidth: true
        Layout.leftMargin: 40
        Layout.rightMargin: 40
        Layout.bottomMargin: 10
        text: qsTr("OK")
        font {
            family: "Liberation Sans"
            pointSize: 13
            capitalization: Font.MixedCase
        }
    }
}
