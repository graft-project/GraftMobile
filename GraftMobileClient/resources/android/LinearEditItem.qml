import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

ColumnLayout {
    property alias title: titleItem.text
    property alias text: editItem.text
    property alias maximumLength: editItem.maximumLength
    spacing: 0

    Text {
        id: titleItem
        Layout.fillWidth: true
        color: "#BBBBBB"
        font.pointSize: 12
    }

    TextField {
        id: editItem
        Layout.fillWidth: true
        color: "#404040"
    }

    Text {
        id: textCount
        Layout.alignment: Qt.AlignRight
        text: qsTr("%1 / %2").arg(editItem.length).arg(editItem.maximumLength)
        color: "#BBBBBB"
        font.pointSize: 12
    }
}
