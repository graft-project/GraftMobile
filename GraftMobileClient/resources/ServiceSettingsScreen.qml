import QtQuick 2.9
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import com.device.platform 1.0
import "components"

BaseScreen {
    id: root
    title: qsTr("Settings")
    screenHeader {
        isNavigationButtonVisible: true
        navigationButtonState: Detector.isPlatform(Platform.IOS | Platform.Desktop)
    }

    Connections {
        target: GraftClient
        onSettingsChanged: serviceSettingsFields.updateSettings()
    }

    ColumnLayout {
        spacing: 0
        anchors {
            fill: parent
            margins: 15
        }

        ServiceSettingsItem {
            id: serviceSettingsFields
            Layout.fillWidth: true
        }

        Item {
            Layout.fillHeight: true
        }

        WideActionButton {
            id: saveButton
            text: Detector.isPlatform(Platform.IOS | Platform.Desktop) ? qsTr("Done") :
                                                                         qsTr("Save changes")
            Layout.alignment: Qt.AlignBottom
            onClicked: {
                disableScreen()
                save()
            }
        }
    }

    function save() {
        if (serviceSettingsFields.save())
        {
            pop()
        }
        enableScreen()
    }
}
