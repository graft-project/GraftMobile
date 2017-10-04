import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import "../components"
import "../"

BaseScreen {
    title: qsTr("Settings")
    screenHeader {
        navigationButtonState: true
        actionButton: true
    }

    ColumnLayout {
        spacing: 0
        anchors.fill: parent

        LinearEditItem {
            title: qsTr("Company Name")
            maximumLength: 50
            Layout.topMargin: 10
            Layout.leftMargin: 10
            Layout.rightMargin: 10
        }

        Rectangle {
            Layout.fillHeight: true
        }

        WideActionButton {
            text: qsTr("Save changes")
            Layout.bottomMargin: 10
            onClicked: pushScreen.doneSaving()
        }
    }
}
