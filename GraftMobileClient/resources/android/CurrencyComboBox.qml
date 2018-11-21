import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

ColumnLayout {
    readonly property alias currentText: graftCBox.currentText
    property alias currencyModel: graftCBox.model
    property alias currencyIndex: graftCBox.currentIndex
    property alias dropdownTitle: dropdownTitle.text

    spacing: 0

    Label {
        id: dropdownTitle
        Layout.fillWidth: true
        color: "#BBBBBB"
        font.pixelSize: 12
    }

    ComboBox {
        id: graftCBox
        Material.background: "#00707070"
        Material.foreground: "#585858"
        textRole: "name"
        Layout.fillWidth: true
        Layout.preferredHeight: 34
        leftPadding: -12
    }

    Rectangle {
        color: "#acacac"
        Layout.fillWidth: true
        Layout.preferredHeight: 1
    }
}
