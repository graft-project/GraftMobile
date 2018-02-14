import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import "../"

BaseSettingsScreen {
    companyTitle: qsTr("Company:")
    ipTitle: qsTr("IP:")
    portTitle: qsTr("Port:")
    saveButtonText: qsTr("Done")

    screenHeader {
        isNavigationButtonVisible: false
        navigationButtonState: true
        actionButtonState: true
        actionText: qsTr("Save")
    }
}
