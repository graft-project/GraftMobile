import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import com.graft.design 1.0

Image {
    source: "qrc:/imgs/cart_icon.png"

    property alias productCount: counterText.text

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
            id: counterText
            anchors.centerIn: parent
            color: ColorFactory.color(DesignFactory.LightText)
            text: "0"
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
