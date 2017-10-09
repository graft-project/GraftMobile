import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import "components"

BaseScreen {
    title: qsTr("Settings")

    property alias companyEditTitle: linearEditItem.title
    property alias saveButtonText: saveButton.text
    
    action: saveChanges

    function saveChanges() {
        pushScreen.openProductScreen()
    }

    ColumnLayout {
        anchors.fill: parent

        LinearEditItem {
            id: linearEditItem
            maximumLength: 50
            Layout.topMargin: 10
            Layout.leftMargin: 10
            Layout.rightMargin: 10
        }

        Rectangle {
            Layout.fillHeight: true
        }

        WideActionButton {
            id: saveButton
            Layout.bottomMargin: 10
            onClicked: saveChanges()
        }
    }
}
