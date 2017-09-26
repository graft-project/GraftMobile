import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import com.graft.design 1.0

Rectangle {
    property real productPrice
    property alias productPriceTextColor: price.color
    property alias productName: productText.text
    property alias productNameTextColor: productText.color
    property alias productNameTextBold: productText.font.bold
    property alias lineTopVisible: topLine.visible
    property alias lineBottomVisible: bottomLine.visible
    property alias productImage: picture.source

    height: layout.height + 2 * 10

    Rectangle {
        id: topLine
        height: 1
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            leftMargin: 12
            rightMargin: 12
        }
        color: ColorFactory.color(DesignFactory.AllocateLine)
    }

    ColumnLayout {
        id: layout
        spacing: 0
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
        }

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
                    width: 50
                    height: 50
                    visible: false
                }
            }

            ColumnLayout {
                spacing: 3
                Layout.alignment: Qt.AlignHCenter

                Text {
                    id: productText
                    Layout.fillWidth: true
                    font.pointSize: 15
                }

                Text {
                    id: price
                    text: "$" + productPrice
                    font.pointSize: 12
                }
            }
        }
    }

    Rectangle {
        id: bottomLine
        height: 1
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            leftMargin: 12
            rightMargin: 12
        }
        color: ColorFactory.color(DesignFactory.AllocateLine)
    }
}
