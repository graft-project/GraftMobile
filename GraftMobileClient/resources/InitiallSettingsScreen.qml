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

    property alias ipTitle: fields.ipTitle
    property alias portTitle: fields.portTitle
    property alias addressTitle: fields.addressTitle

    ColumnLayout {
        spacing: 0
        anchors {
            fill: parent
            margins: 15
        }

        BaseSettingFields {
            id: fields
            displayCompanyName: false
            Layout.fillWidth: true
        }

        Item {
            Layout.fillHeight: true
        }

        WideActionButton {
            id: saveButton
            text: Detector.isPlatform(Platform.IOS | Platform.Desktop) ? qsTr("Done") : qsTr("Save changes")
            Layout.alignment: Qt.AlignBottom
            onClicked: {
                disableScreen()
                save()
            }
        }
    }

    function save() {
        GraftClient.setSettings("httpsType", fields.httpsSwitch)
        if (fields.serviceAddr)
        {
            if (fields.portText !== "" && GraftClient.isValidIp(fields.ipText)) {
                GraftClient.setSettings("useOwnServiceAddress", fields.serviceAddr)
                GraftClient.setSettings("ip", fields.ipText)
                GraftClient.setSettings("port", fields.portText)
            } else {
                screenDialog.text = qsTr("The service IP or port is invalid. Please, enter the " +
                                         "correct service address.")
                screenDialog.open()
                enableScreen()
                return
            }
        } else if (fields.serviceURLSwitch) {
            if (GraftClient.isValidUrl(fields.addressText) &&
                !(fields.addressText === "http://" || fields.addressText === "https://")) {
                GraftClient.setSettings("useOwnUrlAddress", fields.serviceURLSwitch)
                GraftClient.setSettings("address", fields.addressText)
            } else {
                screenDialog.text = qsTr("The service URL is invalid. Please, enter the " +
                                         "correct service address.")
                screenDialog.open()
                enableScreen()
                return
            }
        }
        GraftClient.saveSettings()
        pop()
        enableScreen()
    }
}
