import QtQuick 2.9
import QtQuick.Controls 2.2
import com.graft.design 1.0

Drawer {
    property var pushScreen
    property alias logo: logoImage.source
    default property alias contents: placeholder.data

    height: parent.height
    width: 0.75 * parent.width

    Rectangle {
        id: foreground
        height: parent.height / 4
        width: parent.width
        color: ColorFactory.color(DesignFactory.Foreground)

        Image {
            id: logoImage
            width: parent.width / 1.5
            fillMode: Image.PreserveAspectFit
            anchors {
                left: parent.left
                leftMargin: 25
                top: parent.top
                topMargin: 20
                bottom: parent.bottom
                bottomMargin: 20
            }
        }
    }

    Item {
        id: placeholder
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: foreground.bottom
        }
    }
}
