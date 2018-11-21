import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import "../"

BaseSettingsScreen {
    ipTitle: qsTr("IP")
    portTitle: qsTr("Port")
    saveButtonText: qsTr("Save changes")
    companyTitle: qsTr("Company Name")
    addressTitle: qsTr("Address")

    screenHeader {
        navigationButtonState: true
        actionButtonState: true
    }
}
