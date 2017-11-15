import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import "../"

BaseSettingsScreen {
    companyTitle: qsTr("Company Name")
    ipTitle: qsTr("IP")
    portTitle: qsTr("Port")
    saveButtonText: qsTr("Save changes")

    screenHeader {
        navigationButtonState: true
        actionButtonState: true
    }
}
