import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import com.graft.design 1.0

Rectangle {
    property real productPrice
    property alias productPriceTextColor: price.color
    property alias productText: productText
    property alias lineTopVisible: topLine.visible
    property alias lineBottomVisible: bottomLine.visible
    property alias productImage: picture.source

    height: parent.width / 6 + 20

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

    RowLayout {
        spacing: 0
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

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
