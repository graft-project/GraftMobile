import QtQuick 2.9
import QtQuick.Layouts 1.3
import com.graft.design 1.0

ColumnLayout {
    property real price: 20
    property alias productName: productText.text
    property alias lineVisible: bottomLine.visible

    spacing: 12

    RowLayout {
        Layout.preferredWidth: parent.width
        Layout.topMargin: 12

        Text {
            id: productText
            Layout.alignment: Qt.AlignLeft
            font.pointSize: 12
            color: ColorFactory.color(DesignFactory.MainText)
        }

        Text {
            text: qsTr("$ %1").arg(price)
            Layout.alignment: Qt.AlignRight
            font.pointSize: 12
            color: ColorFactory.color(DesignFactory.MainText)
        }
    }

    Rectangle {
        id: bottomLine
        Layout.fillWidth: true
        Layout.preferredHeight: 2
        color: ColorFactory.color(DesignFactory.AllocateLine)
    }
}
