import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import "../components"
import "../"

BaseScreen {
    id: mainScreen
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
//            wrapMode: TextInput.WordWrap
            maximumLength: 50
//            Layout.fillWidth: true
//            Layout.topMargin: 5
//            Layout.leftMargin: 10
//            Layout.rightMargin: 10
        }

//        Rectangle {
//            Layout.fillHeight: true
//        }

        WideActionButton {
            id: addButton
            text: qsTr("Save changes")
//            Layout.bottomMargin: 10
            onClicked: pushScreen.doneSaving()
        }
    }
}
