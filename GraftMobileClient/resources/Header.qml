import QtQuick 2.9
import QtQuick.Layouts 1.3

Rectangle {
    height: 60
    color: "#707070"

    signal clickMenuIcon()

    property alias headerText: headerText.text
    property alias cartEnable: cartIcon.visible
    property bool menuState: true

    onMenuStateChanged: {
        if (menuState == true)
        {
            menuIcon.source = "qrc:/imgs/menu_icon.png"
        }
        else
        {
            menuIcon.source = "qrc:/imgs/back.png"
        }
    }

    RowLayout {
        anchors.fill: parent
        Layout.topMargin: 10

        Image {
            id: menuIcon
            Layout.maximumWidth: 20
            Layout.maximumHeight: 20
            Layout.alignment: Qt.AlignLeft
            source: "qrc:/imgs/menu_icon.png"

            MouseArea {
                anchors.fill: parent
                onClicked: clickMenuIcon()
            }
        }

        Text {
            id: headerText
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 15
            color: "white"
        }

        Image {
            id: cartIcon
            Layout.maximumWidth: 20
            Layout.maximumHeight: 20
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: 15
            source: "qrc:/imgs/cart_icon.png"
        }
    }
}
