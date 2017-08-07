import QtQuick 2.9
import QtQuick.Layouts 1.3

Rectangle {

    height: 60
    color: "#707070"

    property string menuIcon
    property string headerText
    property string cartIcon

    RowLayout {

        anchors.fill: parent
        Layout.topMargin: 10

        Image{

            Layout.maximumWidth: 20
            Layout.maximumHeight: 20
            Layout.alignment: Qt.AlignLeft

            source: menuIcon
        }

        Text {

            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter

            font.pixelSize: 15
            text: headerText
            color: "white"
        }

        Image {

            Layout.maximumWidth: 20
            Layout.maximumHeight: 20
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: 15

            source: cartIcon
        }
    }
}
