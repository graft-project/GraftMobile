import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.2

Item {
    ListView {
        id: listView
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent
        model: fruitModel
        delegate: fruitDelegate

        RoundButton {
            width: 191
            height: 47
            radius: 11
            highlighted: true
            Material.elevation: 0
            Material.accent: "#757575"
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 94

            Text {
                id: namebutton
                color: "#FFFFFF"
                text: qsTr("Checkout")
                font {
                    family: "Liberation Sans"
                    pixelSize: 16
                }
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        RoundButton {
            width: 57
            height: 57
            radius: 100
            highlighted: true
            Material.elevation: 0
            Material.accent: "#d7d7d7"
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 17
            anchors.rightMargin: 17

            Text {
                id: plusbutton
                color: "#757575"
                text: qsTr("+")
                font {
                    family: "Tlwg Typewriter"
                    pixelSize: 44
                }
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    ListModel {
        id: fruitModel

        ListElement {
            name: "Hairout 1"
            image: "qrc:/examples/bob-haircuts.png"
            cost: 25
        }

        ListElement {
            name: "Hairout 2"
            image: "qrc:/examples/images.png"
            cost: 20
        }
    }

    Component {
        id: fruitDelegate
        ColumnLayout {
            height: 70
            anchors.left: parent.left
            anchors.right: parent.right
            RowLayout {
                spacing: 8
                Layout.rightMargin: 12
                Layout.leftMargin: 12

                OpacityMask {
                    id: opacityMask
                    Layout.preferredWidth: 50
                    Layout.preferredHeight: 50
                    source: picture
                    maskSource: circle

                    Rectangle {
                        id: circle
                        width:  picture.width
                        height: picture.height
                        radius: picture.width / 2
                        visible: false
                    }
                    Image {
                        id: picture
                        source: image
                        width: 50
                        height: 55
                        visible: false
                    }
                }

                Text {
                    text: name
                    Layout.fillWidth: true
                    color: "#757575"
                    font {
                        family: "Liberation Sans"
                        pixelSize: 15
                    }
                }
                Text {
                    text: "$ " + cost
                    color: "#757575"
                    font {
                        family: "Liberation Sans"
                        pixelSize: 15
                    }
                }
            }

            Rectangle{
                Layout.preferredHeight: 1.6
                Layout.alignment: Qt.AlignBottom
                Layout.fillWidth: true
                color: "#bababa"
            }
        }
    }
}
