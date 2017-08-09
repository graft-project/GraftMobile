import QtQuick 2.9
import QtQuick.Layouts 1.3


RowLayout {
    property int totalAmount: 0

    Text {
        text: qsTr("Total: ")
        Layout.alignment: Qt.AlignLeft
        font.pointSize: 12
        color: "#707070"
    }

    Text {
        text: "$ " + totalAmount
        Layout.alignment: Qt.AlignRight
        font.pointSize: 12
        color: "#707070"
    }
}
