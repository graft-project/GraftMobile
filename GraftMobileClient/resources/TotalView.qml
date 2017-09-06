import QtQuick 2.9
import QtQuick.Layouts 1.3

Rectangle {
    property real totalAmount: 0

    radius: 7
    color: "#fedbb4"
    Layout.preferredHeight: 40
    Layout.preferredWidth: 115

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 5
        anchors.rightMargin: 5

        Text {
            text: qsTr("Total: ")
            Layout.alignment: Qt.AlignLeft
            color: "#707070"
            font {
                pointSize: 12
                bold: true
            }
        }

        Text {
            text: "$ " + totalAmount
            Layout.alignment: Qt.AlignRight
            color: "#707070"
            font {
                pointSize: 12
                bold: true
            }
        }
    }
}
