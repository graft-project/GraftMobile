import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import "../"

BaseSettingsScreen {
    companyEditTitle: qsTr("Company Name")
    saveButtonText: qsTr("Save changes")

    screenHeader {
        navigationButtonState: true
        actionButton: true
    }
}
