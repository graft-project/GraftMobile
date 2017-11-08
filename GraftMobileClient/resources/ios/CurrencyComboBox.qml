import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

ColumnLayout {
    readonly property alias currentText: graftCBox.currentText
    property alias currencyModel: graftCBox.model
    property alias currencyIndex: graftCBox.currentIndex
    property alias dropdownTitle: dropdownTitle.text

    spacing: 4

    ComboBox {
        id: graftCBox
        Material.background: "#00707070"
        Material.foreground: "#404040"
        leftPadding: dropdownTitle.width - 8
        Layout.fillWidth: true
        Layout.topMargin: -8
        Layout.bottomMargin: -2
        textRole: "name"

        Text {
            id: dropdownTitle
            anchors {
                top: parent.top
                left: parent.left
                topMargin: 13
            }
            font.pointSize: parent.font.pointSize
            color: "#8e8e93"
        }
    }

    Rectangle {
        height: 1
        color: "#acacac"
        Layout.fillWidth: true
    }
}
