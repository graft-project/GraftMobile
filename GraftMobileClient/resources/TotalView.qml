import QtQuick 2.0
import QtQuick.Layouts 1.3


ColumnLayout{

    anchors.fill: parent

    property string text2: "$ "
    property string text4: "$ "
    property int setTextField2: 0
    property int setTextField4: 0

    RowLayout {

        Layout.preferredWidth: column.width

        Text {
            text: "Haircut 1"
            Layout.alignment: Qt.AlignLeft
            font.pixelSize: 20
            color: "grey"
        }

        Text {
            text: text2 += setTextField2
            Layout.alignment: Qt.AlignRight
            font.pixelSize: 20
            color: "grey"
        }
    }

    Rectangle {
        height: 2
        Layout.preferredWidth: parent.width
        color: "grey"
    }

    RowLayout {

        Layout.preferredWidth: column.width

        Text {
            text: "Total: "
            Layout.alignment: Qt.AlignLeft
            font.pixelSize: 20
            color: "grey"
        }

        Text {
            text: text4 += setTextField4
            Layout.alignment: Qt.AlignRight
            font.pixelSize: 20
            color: "grey"
        }
    }
}
