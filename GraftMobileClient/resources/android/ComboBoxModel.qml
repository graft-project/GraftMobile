import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

ColumnLayout {
    property alias currencyModel: graftCBox.model
    property alias currencyIndex: graftCBox.currentIndex
    property alias dropdownTitle: dropdownTitle.text

    spacing: 4

    Text {
        id: dropdownTitle
        Layout.fillWidth: true
        color: "#BBBBBB"
        font.pointSize: 12
    }

    ComboBox {
        id: graftCBox
        Layout.fillWidth: true
        Material.background: "#00707070"
        Material.foreground: "#585858"
        leftPadding: -12
        Layout.topMargin: -12
        Layout.bottomMargin: -10
        textRole: "name"
    }

    Rectangle {
        height: 1
        color: "#acacac"
        Layout.fillWidth: true
    }
}
