import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import "../"

BaseSettingsScreen {
    companyEditTitle: qsTr("Company: ")
    saveButtonText: qsTr("Done")

    screenHeader {
        actionButtonState: true
        actionText: qsTr("Save")
    }
}
