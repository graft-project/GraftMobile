import QtQuick 2.9
import QtQuick.Layouts 1.3

RowLayout {
    property string name: walletName.text
    property string number: walletNumber.text

    Layout.preferredWidth: parent.width

    Text {
        id: walletName
        Layout.alignment: Qt.AlignLeft
        color: "white"
        font {
            family: "Liberation Sans"
            pointSize: 12
        }
        text: qsTr(name)
    }

    Text {
        id: walletNumber
        Layout.alignment: Qt.AlignRight
        color: "white"
        font {
            family: "Liberation Sans"
            pointSize: 12
        }
        text: qsTr(number)
    }
}
