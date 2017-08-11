import QtQuick 2.9
import QtQuick.Layouts 1.3

ColumnLayout {
    property int price: 20
    property alias productName: productText.text

    spacing: 12

    RowLayout {
        Layout.preferredWidth: parent.width
        Layout.topMargin: 12

        Text {
            id: productText
            Layout.alignment: Qt.AlignLeft
            font.pointSize: 12
            color: "#707070"
        }

        Text {
            text: qsTr("$ %1").arg(price)
            Layout.alignment: Qt.AlignRight
            font.pointSize: 12
            color: "#707070"
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 2
        color: "#d7d7d7"
    }
}
