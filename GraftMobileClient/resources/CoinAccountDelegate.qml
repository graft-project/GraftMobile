import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.2

Button {
    property alias accountBalance: accountBalance.text
    property alias accountTitle: accountName.text
    property alias productImage: picture.source
    property alias topLineVisible: topLine.visible
    property alias bottomLineVisible: bottomLine.visible

    height: 60
    flat: true
    background {
        x: 0
        y: 0
        width: background.parent.width
        height: background.parent.height
    }
    onClicked: {} //написати

    ColumnLayout {
        spacing: 0
        anchors {
            fill: parent
            leftMargin: 15
            rightMargin: 15
        }

        Rectangle {
            id: topLine
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: "#e6e6e8"
        }

        RowLayout {
            spacing: 0
            Layout.alignment: Qt.AlignHCenter

            OpacityMask {
                id: opacityMask
                maskSource: circle
                Layout.preferredWidth: 46
                Layout.preferredHeight: 46
                Layout.alignment: Qt.AlignLeft
                source: picture

                Rectangle {
                    id: circle
                    width: picture.width
                    height: picture.height
                    visible: false
                    radius: picture.width / 2
                }

                Image {
                    id: picture
                    width: 46
                    height: 46
                    visible: false
                }
            }

            Text {
                id: accountName
                color: "#000000"
                font.pointSize: 20
                Layout.fillWidth: true
                Layout.leftMargin: 15
                Layout.alignment: Qt.AlignLeft
            }

            Text {
                id: accountBalance
                color: "#404040"
                font.pointSize: 20
                Layout.rightMargin: 15
                Layout.alignment: Qt.AlignRight
            }

            Image {
                source: "qrc:/imgs/arrow.png"
                Layout.preferredHeight: 20
                Layout.preferredWidth: 12
                Layout.alignment: Qt.AlignRight
            }
        }

        Rectangle {
            id: bottomLine
            color: "#e6e6e8"
            Layout.fillWidth: true
            Layout.preferredHeight: 1
        }
    }
}
