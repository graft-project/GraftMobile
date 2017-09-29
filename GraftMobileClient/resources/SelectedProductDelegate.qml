import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Rectangle {
    property real productPrice
    property alias productPriceTextColor: price.color
    property alias productText: productText
    property alias topLineVisible: topLine.visible
    property alias bottomLineVisible: bottomLine.visible
    property alias productImage: picture.source
    property bool hideTopLineMargin: false
    property bool hideBottomLineMargin: false

    onHideTopLineMarginChanged: {
        topLine.anchors.rightMargin = hideTopLineMargin ? 0 : 12
    }

    onHideBottomLineMarginChanged: {
        bottomLine.anchors.rightMargin = hideBottomLineMargin ? 0 :12
    }

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
        color: "#e6e6e8"
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
            Layout.preferredWidth: 46
            Layout.preferredHeight: 46
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
                width: 46
                height: 46
                visible: false
            }

            Rectangle {
                id: greyPicture
                width: picture.width
                height: picture.height
                visible: false
                color: "#d1d3d4"
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
        color: "#e6e6e8"
    }
}
