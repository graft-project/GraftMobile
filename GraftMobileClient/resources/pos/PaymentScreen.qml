import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

ColumnLayout {
    property int price

    RowLayout {
        spacing: 46
        Layout.topMargin: 20
        Layout.leftMargin: 15
        Layout.rightMargin: 15
        Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
        Layout.bottomMargin: 15

        ColumnLayout {
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

        Rectangle {
            id: qRCodePicture
            height: 95
            width: 95

            Image {
                width: qRCodePicture.width
                height: qRCodePicture.height
                source: "qrc:/examples/QRCode_images.png"
            }
        }
    }

    Rectangle {
        Layout.preferredHeight: 1.6
        Layout.alignment: Qt.AlignBottom
        Layout.fillWidth: true
        color: "#d7d7d7"
    }

    ListView {
        Layout.fillWidth: true
        Layout.fillHeight: true
//        model: b
//        delegate: a

//        Component {
//            id: a
//        }

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 11

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
