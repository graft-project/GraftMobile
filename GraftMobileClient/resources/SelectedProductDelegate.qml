import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2
import com.graft.design 1.0

//Rectangle {
//    property real productPrice
//    property alias productPriceTextColor: price.color
//    property alias productText: productText
//    property alias lineTopVisible: topLine.visible
//    property alias lineBottomVisible: bottomLine.visible
//    property alias productImage: picture.source

//    height: parent.width / 6 + 20

//    Rectangle {
//        id: topLine
//        height: 1
//        anchors {
//            top: parent.top
//            left: parent.left
//            right: parent.right
//            leftMargin: 12
//            rightMargin: 12
//        }
//        color: ColorFactory.color(DesignFactory.AllocateLine)
//    }

//    RowLayout {
//        spacing: 0
//        anchors {
//            left: parent.left
//            right: parent.right
//            verticalCenter: parent.verticalCenter
//        }

//        OpacityMask {
//            id: opacityMask
//            maskSource: circle
//            Layout.leftMargin: 12
//            Layout.rightMargin: 12
//            Layout.preferredWidth: 50
//            Layout.preferredHeight: 50
//            source: picture.status === Image.Ready ? picture : greyPicture

//            Rectangle {
//                id: circle
//                width: picture.width
//                height: picture.height
//                radius: picture.width / 2
//                visible: false
//            }

//            Image {
//                id: picture
//                width: 50
//                height: 50
//                visible: false
//            }

//            Rectangle {
//                id: greyPicture
//                width: picture.width
//                height: picture.height
//                visible: false
//                color: ColorFactory.color(DesignFactory.AllocateLine)
//            }
//        }

//        ColumnLayout {
//            spacing: 3
//            Layout.alignment: Qt.AlignHCenter

//            Text {
//                id: productText
//                Layout.fillWidth: true
//                font.pointSize: 16
//            }

//            Text {
//                id: price
//                text: "$" + productPrice
//                font.pointSize: 14
//            }
//        }
//    }

//    Rectangle {
//        id: bottomLine
//        height: 1
//        anchors {
//            bottom: parent.bottom
//            left: parent.left
//            right: parent.right
//            leftMargin: 12
//            rightMargin: 12
//        }
//        color: ColorFactory.color(DesignFactory.AllocateLine)
//    }
//}

//import QtQuick.Controls 2.2
//import QtQuick.Layouts 1.3
//import QtQuick 2.9

SwipeDelegate {
    id: root

    property real productPrice
    property alias productPriceTextColor: price.color
    property alias productText: productText
//    property alias lineTopVisible: topLine.visible
//    property alias lineBottomVisible: bottomLine.visible
    property alias productImage: picture.source

    height: parent.width / 6 + 20
    focusPolicy: Qt.ClickFocus
    onActiveFocusChanged: if(!focus || root.swipe.complete) swipe.close()

//    Rectangle {
//        id: topLine
////        height: 1
//        anchors {
//            top: parent.top
//            left: parent.left
//            right: parent.right
//            leftMargin: 12
//            rightMargin: 12
//        }
//        color: ColorFactory.color(DesignFactory.AllocateLine)
//    }

    RowLayout {
        spacing: 0

        x: contentItem.x
        y: contentItem.y
        z: contentItem.z
        width: contentItem.width
        height: contentItem.height

//        anchors {
//            left: parent.left
//            right: parent.right
//            verticalCenter: parent.verticalCenter
//        }

        OpacityMask {
            id: opacityMask
            maskSource: circle
            Layout.leftMargin: 12
            Layout.rightMargin: 12
            Layout.preferredWidth: 50
            Layout.preferredHeight: 50
            source: picture.status === Image.Ready ? picture : greyPicture

            Rectangle {
                id: circle
                width: picture.width
                height: picture.height
                radius: picture.width / 2
                visible: false
            }

            Image {
                id: picture
                width: 50
                height: 50
                visible: false
            }

            Rectangle {
                id: greyPicture
                width: picture.width
                height: picture.height
                visible: false
                color: ColorFactory.color(DesignFactory.AllocateLine)
            }
        }

        ColumnLayout {
            spacing: 3
            Layout.alignment: Qt.AlignHCenter

            Text {
                id: productText
                Layout.fillWidth: true
                font.pointSize: 16
            }

            Text {
                id: price
                text: "$" + productPrice
                font.pointSize: 14
            }
        }
    }

//    Rectangle {
//        id: bottomLine
//        height: 1
//        anchors {
//            bottom: parent.bottom
//            left: parent.left
//            right: parent.right
//            leftMargin: 12
//            rightMargin: 12
//        }
//        color: ColorFactory.color(DesignFactory.AllocateLine)
//    }

    swipe.right: Component {/*Button {
        anchors.right: parent.right
        width: 150
        height: 8
        text: "zxcvghjkl"
        enabled: root.swipe.complete
        background {
            y: 0
            height: root.height
        }*/
        /*contentItem: */
        RowLayout {
                width: 120
                spacing: 0

                height: parent.height
                anchors.right: parent.right

                Rectangle {
                    Layout.preferredHeight: parent.height
                    Layout.preferredWidth: parent.width / 2
//                    color: ColorFactory.color(DesignFactory.ItemText)
                    color: "#e5e7ea"

                    Image {
                        anchors.centerIn: parent
                        height: parent.height / 3
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/imgs/edit.png"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("PAINT!!!")
                        }
                    }
                }

                Rectangle {
                    Layout.preferredHeight: parent.height
                    Layout.preferredWidth: parent.width / 2
                    color: ColorFactory.color(DesignFactory.CartLabel)

                    Image {
                        anchors.centerIn: parent
                        height: parent.height / 3
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/imgs/delete.png"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("DELETE!!!")
                        }
                    }
                }
            }
    }

//        colorRemoveButton: "#04a197"
//        onRemoveClicked: remove(id)
//    }
}
