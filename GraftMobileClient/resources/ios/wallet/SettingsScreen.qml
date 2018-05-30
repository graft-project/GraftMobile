import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import "../"

BaseSettingsScreen {
    ipTitle: qsTr("IP:")
    portTitle: qsTr("Port:")
    saveButtonText: qsTr("Done")
    addressTitle: qsTr("Address:")
    displayCompanyName: false

    screenHeader {
        isNavigationButtonVisible: false
        navigationButtonState: true
        actionButtonState: true
        actionText: qsTr("Save")
    }
}
