import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import "components"

BaseScreen {
    property alias companyEditTitle: linearEditItem.title
    property alias saveButtonText: saveButton.text
    
    title: qsTr("Settings")
    action: saveChanges

    function saveChanges() {
        GraftClient.setSettings("companyName", linearEditItem.text)
        GraftClient.saveSettings()
        pushScreen.openProductScreen()
    }

    ColumnLayout {
        spacing: 0
        anchors {
            fill: parent
            leftMargin: 15
            rightMargin: 15
        }

        LinearEditItem {
            id: linearEditItem
            maximumLength: 50
            Layout.topMargin: 10
            Layout.leftMargin: 5
            Layout.rightMargin: 5
            Layout.alignment: Qt.AlignTop
            text: GraftClient.settings("companyName") ? GraftClient.settings("companyName") : ""
        }

        WideActionButton {
            id: saveButton
            Layout.alignment: Qt.AlignBottom
            Layout.bottomMargin: 15
            onClicked: saveChanges()
        }
    }
}
