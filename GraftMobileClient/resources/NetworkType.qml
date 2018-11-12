import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0

ColumnLayout {
    property alias type: type.text
    property alias networkChecked: type.checked
    property alias networkDescription: description.text

    signal typeSelected()

    spacing: 0

    RadioButton {
        id: type
        Layout.preferredHeight: 30
        Material.accent: ColorFactory.color(DesignFactory.Foreground)
        Material.foreground: ColorFactory.color(DesignFactory.Foreground)
        text: qsTr("Mainnet")
        font {
            pixelSize: 16
            bold: true
        }
        checkable: false
        MouseArea {
            anchors.fill: parent
            onClicked: typeSelected()
        }
    }

    Label {
        id: description
        Layout.fillWidth: true
        Layout.leftMargin: 35
        Layout.rightMargin: 20
        color: "#BBBBBB"
        font.pixelSize: 14
        wrapMode: Text.WordWrap
        text: qsTr("Actual GRAFT blockchain, production network. This is the blockchain " +
                   "that carry real GRFT transactions.")
        MouseArea {
            anchors.fill: parent
            onClicked: typeSelected()
        }
    }
}
