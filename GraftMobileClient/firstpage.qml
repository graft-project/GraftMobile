import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3

Item {
    id: item1
    ListView {
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent
        model: fruitModel
        delegate: fruitDelegate

        Rectangle{
            x: 270
            y: 360
            width: 186
            height: 30

            Layout.preferredHeight: 40
            Layout.alignment: Qt.AlignBottom
            Layout.fillWidth: true
            color: "#757575"
            radius: 10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20

            Text
            {
                id: namebutton
                color: "#FFFFFF"
                text: qsTr("Checkout")
                horizontalAlignment: Text.AlignHCenter
                styleColor: "#201e1e"
                font {
                    family: "Liberation Sans Narrow"
                    pixelSize: 17
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
            cost: 25
            image: "qrc:/examples/bob-haircuts.png"
        }

        ListElement {
            name: "Hairout 2"
            cost: 20
            image: "qrc:/examples/images.png"
        }
    }


    Component {
        id: fruitDelegate
        ColumnLayout {
            anchors.left: parent.left
            anchors.leftMargin: 17
            anchors.right: parent.right
            anchors.rightMargin: 17
            height: 70
            spacing: 3
            RowLayout {
                spacing: 10

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
                    //                Layout.preferredWidth: 50
                    text: name
                    Layout.fillWidth: true
                    color: "#757575"
                    //                Rectangle {
                    //                color: "red"
                    //                anchors.fill: parent
                    //                }
                }
                Text {
                    //                Layout.preferredWidth: 50
                    text: '$' + cost
                    color: "#757575"

                    //                Rectangle {
                    //                color: "red"
                    //                anchors.fill: parent
                    //                }
                }
            }

            Rectangle{
                Layout.preferredHeight: 1.7
                Layout.alignment: Qt.AlignBottom
                Layout.fillWidth: true
                color: "#757575"
            }
        }
    }
}
