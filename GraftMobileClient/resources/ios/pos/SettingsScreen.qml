import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import "../components"
import "../"

BaseScreen {
    title: qsTr("Settings")
    screenHeader {
        actionButtonState: true
        actionText: qsTr("Save")
    }

    ColumnLayout {
        anchors.fill: parent

        LinearEditItem {
            title: qsTr("Company:")
            maximumLength: 50
            Layout.topMargin: 5
            Layout.leftMargin: 10
            Layout.rightMargin: 10
        }

        Rectangle {
            Layout.fillHeight: true
        }

        WideActionButton {
            text: qsTr("Done")
            Layout.bottomMargin: 10
            onClicked: pushScreen.doneSaving()
        }
    }
}
