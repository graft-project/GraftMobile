import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2

Button {
    padding: 0
    contentItem: Rectangle {
        color: "#FFFFFF"

        Rectangle {
            id: topLine
            height: 1
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                leftMargin: 16
                rightMargin: 16
            }
            visible: Qt.platform.os === "ios"
            color: "#E6E6E8"
        }

        RowLayout {
            anchors {
                top: topLine.bottom
                bottom: bottomLine.top
                left: parent.left
                right: parent.right
                leftMargin: 16
            }
            spacing: 10

            Image {
                Layout.preferredHeight: 46
                Layout.preferredWidth: 46
                source: "qrc:/imgs/add.png"
            }

            Text {
                Layout.alignment: Text.AlignLeft
                text: qsTr("Add new product")
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
            visible: Qt.platform.os === "ios"
            color: "#E6E6E8"
        }
    }
}
