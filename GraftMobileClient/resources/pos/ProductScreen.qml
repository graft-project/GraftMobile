import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.2

Item {
    ListView {
        id: productList
        anchors.fill: parent
        model: productModel
        delegate: productDelegate

        RoundButton {
            id: addButton
            radius: 14
            topPadding: 15
            bottomPadding: 15
            highlighted: true
            Material.elevation: 0
            Material.accent: "#757575"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 94
            anchors.right: parent.right
            anchors.rightMargin: 40
            anchors.left: parent.left
            anchors.leftMargin: 40
            text: qsTr("Checkout")
            font {
                family: "Liberation Sans Narrow"
                pointSize: 14
                capitalization: Font.MixedCase
            }
        }

        RoundButton {
            padding: 21
            width: height
            highlighted: true
            Material.elevation: 0
            Material.accent: "#d7d7d7"
            contentItem: Image {
                source: "qrc:/imgs/plus_icon.png"
            }
            anchors.top: addButton.bottom
            anchors.topMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
        }
    }

    ListModel {
        id: productModel

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
        id: productDelegate

        ColumnLayout {
            height: 70
            anchors.left: parent.left
            anchors.right: parent.right

            RowLayout {
                spacing: 16
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
                        family: "Liberation Sans Narrow"
                        pointSize: 15
                    }
                }

                Text {
                    text: "$ " + cost
                    color: "#757575"
                    font {
                        family: "Liberation Sans Narrow"
                        pointSize: 15
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
