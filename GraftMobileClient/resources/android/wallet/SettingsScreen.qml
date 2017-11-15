import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import "../"

BaseSettingsScreen {
    id: root
    ipTitle: qsTr("IP")
    portTitle: qsTr("Port")
    saveButtonText: qsTr("Save changes")
    visibleCompanyName: false

    screenHeader {
        navigationButtonState: true
        actionButtonState: true
    }
}
