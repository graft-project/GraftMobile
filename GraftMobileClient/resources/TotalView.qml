import QtQuick 2.0
import QtQuick.Layouts 1.3


ColumnLayout{

    property int amountPerItem: 0

    RowLayout {
        Layout.preferredWidth: parent.width

        Text {
            text: qsTr("Haircut 1")
            Layout.alignment: Qt.AlignLeft
            font.pixelSize: 20
            color: "#707070"
        }

        Text {
            text: "$ " + amountPerItem
            Layout.alignment: Qt.AlignRight
            font.pixelSize: 20
            color: "#707070"
        }
    }

    Rectangle {
        height: 2
        Layout.fillWidth: true
        color: "#707070"
    }

    RowLayout {
        Layout.preferredWidth: parent.width

        Text {
            text: qsTr("Total: ")
            Layout.alignment: Qt.AlignLeft
            font.pixelSize: 20
            color: "#707070"
        }

        Text {
            text: "$ " + amountPerItem
            Layout.alignment: Qt.AlignRight
            font.pixelSize: 20
            color: "#707070"
        }
    }
}
