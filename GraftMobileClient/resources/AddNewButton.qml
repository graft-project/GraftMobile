import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.device.platform 1.0

Button {
    property alias buttonTitle: buttonTitle.text
    property alias bottomLine: bottomLine.visible
    property alias topLine: topLine.visible

    padding: 0
    contentItem: Rectangle {
        anchors {
            left: parent.left
            right: parent.right
        }
        color: "#FFFFFF"

        Rectangle {
            id: topLine
            height: 1
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                leftMargin: 15
                rightMargin: 15
            }
            visible: Detector.isPlatform(Platform.IOS | Platform.Desktop)
            color: "#E6E6E8"
        }

        RowLayout {
            anchors {
                fill: parent
                leftMargin: 15
            }
            spacing: 0

            Image {
                Layout.preferredHeight: 46
                Layout.preferredWidth: 46
                source: "qrc:/imgs/add.png"
                horizontalAlignment: Image.AlignLeft
            }

            Text {
                id: buttonTitle
                Layout.fillWidth: true
                Layout.leftMargin: 15
                horizontalAlignment: Text.AlignLeft
            }
        }

        Rectangle {
            id: bottomLine
            height: 1
            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
                leftMargin: 15
                rightMargin: 15
            }
            visible: Detector.isPlatform(Platform.IOS | Platform.Desktop)
            color: "#E6E6E8"
        }
    }
}
