import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import com.graft.design 1.0
import "../"

BaseHeader {
    id: rootItem
    height: 60
    onMenuStateChanged: {
        console.log("AAAAAAA")
//        if (menuState) {
//            menuIcon.source = "qrc:/imgs/menu_icon.png"
//        } else {
//            menuIcon.source = "qrc:/imgs/back.png"
//        }
    }

    onCartEnableChanged: {
        console.log("BBBBB")
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 15
        anchors.rightMargin: 15

        Image {
            id: menuIcon
            Layout.preferredHeight: 18
            Layout.preferredWidth: 24
            Layout.alignment: Qt.AlignLeft
            source: "qrc:/imgs/menu_icon.png"

            MouseArea {
                anchors.fill: parent
                onClicked: menuIconClicked()
            }
        }

        Text {
            text: rootItem.headerText
            Layout.fillWidth: true
            Layout.leftMargin: 25
            horizontalAlignment: Text.AlignLeft
            font {
                bold: true
                pointSize: 17
            }
            color: ColorFactory.color(DesignFactory.LightText)
        }

        Image {
            visible: rootItem.cartEnable
            Layout.preferredHeight: 30
            Layout.preferredWidth: 30
            Layout.alignment: Qt.AlignRight
            source: "qrc:/imgs/cart_icon.png"

            Rectangle {
                id: circle
                width: picture.width
                height: width
                radius: picture.width / 2
                visible: false
            }

            Rectangle {
                id: picture
                anchors {
                    verticalCenter: parent.top
                    verticalCenterOffset: 6
                    horizontalCenter: parent.right
                    horizontalCenterOffset: -2
                }
                width: 16
                height: width
                color: ColorFactory.color(DesignFactory.CartLabel)
                visible: false

                Text {
                    anchors {
                        centerIn: parent
                    }
                    color: ColorFactory.color(DesignFactory.LightText)
                    text: rootItem.selectedProductCount
                    font {
                        pointSize: 10
                        bold: true
                    }
                }
            }

            OpacityMask {
                anchors.fill: picture
                source: picture
                maskSource: circle
            }
        }

        Image {
            visible: rootItem.doneEnable
            Layout.preferredHeight: 15
            Layout.preferredWidth: 23
            Layout.alignment: Qt.AlignRight
            source: "qrc:/imgs/done.png"

            MouseArea {
                anchors.fill: parent
                onClicked: menuDoneClicked()
            }
        }
    }
}
