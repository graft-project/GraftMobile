import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import com.device.platform 1.0
import org.navigation.attached.properties 1.0

ColumnLayout {
    id: networkType

    property alias type: type.text
    property alias networkChecked: type.checked
    property alias networkDescription: description.text
    property ButtonGroup group: null

    spacing: 0
    Navigation.implicitFirstComponent: type
    onGroupChanged: {
        if (group) {
            group.addButton(type)
        }
    }

    RadioButton {
        id: type
        Layout.preferredHeight: 34
        Material.accent: ColorFactory.color(DesignFactory.Foreground)
        Material.foreground: ColorFactory.color(DesignFactory.Foreground)
        focusPolicy: Detector.isMobile() ? Qt.ClickFocus : Qt.StrongFocus
        KeyNavigation.tab: networkType.Navigation.explicitLastComponent
        KeyNavigation.backtab: networkType.Navigation.explicitFirstComponent
        font {
            pixelSize: 16
            bold: true
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

        MouseArea {
            anchors.fill: parent
            onClicked: {
                type.checked = true
                type.forceActiveFocus()
            }
        }
    }
}
