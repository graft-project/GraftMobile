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
        Layout.preferredWidth: parent.width
        Layout.topMargin: 20
        Layout.leftMargin: 15
        Layout.rightMargin: 15
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
        Layout.bottomMargin: 15

        ColumnLayout {
            id: totalCost
            Layout.alignment: Qt.AlignLeft
            spacing: 12

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
            Layout.alignment: Qt.AlignRight
            Layout.preferredHeight: totalCost.height
            Layout.preferredWidth: totalCost.height
            source: "qrc:/examples/QRCode_images.png"
        }
    }

    Rectangle {
        Layout.preferredHeight: 1.6
        Layout.alignment: Qt.AlignBottom
        Layout.fillWidth: true
        color: "#d7d7d7"
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
        ListElement {
            name: "Hairout 6"
            cost: 20
        }
        ListElement {
            name: "Hairout 7"
            cost: 20
        }
        ListElement {
            name: "Hairout 8"
            cost: 20
        }
        ListElement {
            name: "Hairout 9"
            cost: 20
        }
        ListElement {
            name: "Hairout 10"
            cost: 20
        }
    }

    ListView {
        id: viewProduct
        clip: true
        model: selectedProduct
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.leftMargin: 10
        Layout.rightMargin: 10
        Layout.topMargin: 10
        Layout.bottomMargin: 10
        enabled: !time.visible
        delegate: SelectedProductDelegate {
            width: viewProduct.width
            productName: name
            price: cost
        }

        Timer {
            interval: 1000
            running: true
            onTriggered: {
                control.visible = true
                bottomCancel.visible = true

            }
        }

        BusyIndicator {
            id: control
            anchors.centerIn: parent
            visible: false
        }

        Timer {
            interval: 3000
            running: true
            onTriggered: {
                time.visible = true
                bottomOk.visible = true
                bottomCancel.visible = false
            }
        }

        Rectangle {
            id: time
            visible: false
            anchors.fill: parent
            color: "#99ffffff"
            ColumnLayout {
                spacing: 11
                anchors.centerIn: parent
                Image {
                    source: "qrc:/imgs/paid_icon.png"
                    Layout.preferredHeight: 100
                    Layout.preferredWidth: 100
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: qsTr("PAID !")
                    color: "#757575"
                    font {
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
        topPadding: 13
        bottomPadding: 13
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
        radius: 14
        visible: false
        topPadding: 13
        bottomPadding: 13
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
