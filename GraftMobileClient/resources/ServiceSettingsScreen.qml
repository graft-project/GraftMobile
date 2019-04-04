import QtQuick 2.9
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import com.device.platform 1.0
import org.navigation.attached.properties 1.0
import "components"

BaseScreen {
    id: root
    title: qsTr("Settings")
    screenHeader {
        isNavigationButtonVisible: true
        navigationButtonState: !Detector.isPlatform(Platform.Android)
    }

    Connections {
        target: GraftClient
        onSettingsChanged: serviceSettingsFields.updateSettings()
    }

    ColumnLayout {
        spacing: 0
        anchors {
            fill: parent
            topMargin: 15
            leftMargin: 15
            rightMargin: 15
            bottomMargin: Detector.bottomNavigationBarHeight() + 15
        }

        ServiceSettingsItem {
            id: serviceSettingsFields
            Layout.fillWidth: true
            addressTitle: Detector.isPlatform(Platform.Android) ? qsTr("Address") : qsTr("Address:")
            portTitle: Detector.isPlatform(Platform.Android) ? qsTr("Port") : qsTr("Port:")
            ipTitle: Detector.isPlatform(Platform.Android) ? qsTr("IP") : qsTr("IP:")
        }

        Item {
            Layout.fillHeight: true
        }

        WideActionButton {
            id: saveButton
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignBottom | Qt.AlignCenter
            text: Detector.isPlatform(Platform.Android) ? qsTr("Save changes") : qsTr("Done")
            KeyNavigation.tab: root.Navigation.implicitFirstComponent
            onClicked: {
                disableScreen()
                save()
            }
        }
    }

    function save() {
        if (serviceSettingsFields.save()) {
            pop()
        }
        enableScreen()
    }
}
