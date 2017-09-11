import QtQuick 2.9
import QtQuick.Layouts 1.3
import com.graft.design 1.0

Rectangle {
    property real totalAmount: 0

    radius: 7
    color: ColorFactory.color(DesignFactory.ItemHighlighting)
    Layout.preferredHeight: 40
    Layout.preferredWidth: 115

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 5
        anchors.rightMargin: 5

        Text {
            text: qsTr("Total: ")
            Layout.alignment: Qt.AlignLeft
            color: ColorFactory.color(DesignFactory.MainText)
            font {
                pointSize: 12
                bold: true
            }
        }

        Text {
            text: "$ " + totalAmount
            Layout.alignment: Qt.AlignRight
            color: ColorFactory.color(DesignFactory.MainText)
            font {
                pointSize: 12
                bold: true
            }
        }
    }
}
