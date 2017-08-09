import QtQuick 2.9
import QtQuick.Layouts 1.3

Rectangle {
    height: 60
    color: "#707070"

    property alias menuIcon: menuIcon.source
//    property alias headerText: headerText.text
    property alias cartIcon: cartIcon.source

    RowLayout {
        anchors.fill: parent
        Layout.topMargin: 10

        Image {
            id: menuIcon
            Layout.maximumWidth: 20
            Layout.maximumHeight: 20
            Layout.alignment: Qt.AlignLeft
        }

//        Text {
//            id: headerText
//            Layout.fillWidth: true
//            horizontalAlignment: Text.AlignHCenter
//            font.pixelSize: 15
//            color: "white"
//        }

        Image {
            id: cartIcon
            Layout.maximumWidth: 20
            Layout.maximumHeight: 20
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: 15
        }
    }
}
