import QtQuick 2.9
import QtQuick.Layouts 1.3

ColumnLayout {
    property int priceForTheProduct: 20
    property int index: 0

    RowLayout {
        Layout.preferredWidth: parent.width

        Text {
            text: qsTr("Haircut %1").arg(index+1)
            Layout.alignment: Qt.AlignLeft
            font.pointSize: 12
            color: "#707070"
        }

        Text {
            text: qsTr("$ %1").arg(priceForTheProduct)
            Layout.alignment: Qt.AlignRight
            font.pointSize: 12
            color: "#707070"
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 2
        color: "#707070"
    }
}
