import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.2
import QtQuick.Controls.Universal 2.2

Item {
    ListView {
        id: listGoods
        anchors.fill: parent
        model: goodsModel
        delegate: goodsDelegate

        RoundButton {
            topPadding: 15
            bottomPadding: 15
            leftPadding: 61
            rightPadding: 61
            highlighted: true
            Material.elevation: 0
            Material.accent: "#757575"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 94
            text: qsTr("Checkout")
            font {
                family: "Liberation Sans"
                pixelSize: 16
                capitalization: Font.MixedCase
            }
        }

        RoundButton {
            topPadding: 24
            bottomPadding: 24
            leftPadding: 40
            rightPadding: 24
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
        id: goodsModel

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
        id: goodsDelegate
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
                        width: picture.width
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

            Rectangle {
                Layout.preferredHeight: 1.6
                Layout.alignment: Qt.AlignBottom
                Layout.fillWidth: true
                color: "#d7d7d7"
            }
        }
    }
}
