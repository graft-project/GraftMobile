import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

ColumnLayout {
    readonly property alias currentText: graftCBox.currentText
    property alias currencyModel: graftCBox.model
    property alias currencyIndex: graftCBox.currentIndex
    property alias dropdownTitle: dropdownTitle.text

    spacing: 0

    ComboBox {
        id: graftCBox
        Material.background: "#00707070"
        Material.foreground: "#404040"
        textRole: "code"
        leftPadding: dropdownTitle.width - 8
        Layout.fillWidth: true
        Layout.topMargin: -6
        Layout.bottomMargin: -4
        font.pixelSize: 16
        delegate: ItemDelegate {
            anchors {
                left: parent.left
                right: parent.right
            }
            contentItem: Label {
                text: code
                color: "#A4A9AA"
                font.pixelSize: 16
                elide: Label.ElideRight
                verticalAlignment: Label.AlignVCenter
            }
            highlighted: graftCBox.highlightedIndex === index
        }

        Label {
            id: dropdownTitle
            anchors {
                top: parent.top
                left: parent.left
                topMargin: 14
            }
            color: "#8e8e93"
            font.pixelSize: parent.font.pixelSize
        }
    }

    Rectangle {
        color: "#acacac"
        Layout.fillWidth: true
        Layout.preferredHeight: 1
    }
}
