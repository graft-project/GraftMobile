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
    action: save

    property alias saveButtonText: saveButton.text
    property var confirmPasswordAction: null
    property string message: ""
    property bool okMode: false

    property alias displayCompanyName: fields.displayCompanyName
    property alias companyTitle: fields.companyTitle
    property alias addressTitle: fields.addressTitle
    property alias portTitle: fields.portTitle
    property alias ipTitle: fields.ipTitle

    Connections {
        target: GraftClient
        onSettingsChanged: {
            fields.updateSettings()
        }
    }

    ColumnLayout {
        spacing: 0
        anchors {
            fill: parent
            margins: 15
        }

        BaseSettingFields {
            id: fields
            Layout.fillWidth: true
        }

        Item {
            Layout.fillHeight: true
        }

        WideActionButton {
            id: resetWalletButton
            text: qsTr("Reset Account")
            onClicked: {
                okMode = true
                confirmPasswordAction = resetWalletAccount
                passwordDialog.open()
            }
        }

        WideActionButton {
            id: mnemonicButton
            text: qsTr("Show Mnemonic Password")
            onClicked: {
                okMode = false
                confirmPasswordAction = openMnemonicScreen
                passwordDialog.open()
            }
        }

        WideActionButton {
            id: saveButton
            Layout.alignment: Qt.AlignBottom
            onClicked: {
                disableScreen()
                save()
            }
        }
    }

    ChooserDialog {
        id: passwordDialog
        title: qsTr("Enter password:")
        topMargin: (parent.height - passwordDialog.height) / 2
        leftMargin: (parent.width - passwordDialog.width) / 2
        denyButton {
            text: qsTr("Close")
            onClicked: {
                passwordTextField.clear()
                passwordDialog.close()
            }
        }
        confirmButton {
            text: qsTr("Ok")
            onClicked: {
                passwordDialog.confirmButton.enabled = false
                passwordDialog.accept()
            }
        }
        onAccepted: checkingPassword(passwordTextField.text)
        onVisibleChanged: confirmButton.enabled = true
    }

    MessageDialog {
        id: mobileMessageDialog
        standardButtons: StandardButton.Yes | StandardButton.No
        title: qsTr("Attention")
        icon: StandardIcon.Warning
        text: qsTr("Would you like to reset the service settings %1?").arg(message)
        onNo: {
            restoreSettings()
            mobileMessageDialog.close()
        }
        onYes: {
            resetOwnServiceSettings()
            confirmPasswordAction()
            mobileMessageDialog.close()
        }
    }

    DesktopMessageDialog {
        id: desktopMessageDialog
        topMargin: (parent.height - desktopMessageDialog.height) / 2
        leftMargin: 20
        rightMargin: 20
        modal: true
        padding: 5
        messageTitle: qsTr("Would you like to reset the service settings %1?").arg(message)
        firstButton {
            flat: true
            text: qsTr("No")
            onClicked: {
                restoreSettings()
                desktopMessageDialog.close()
            }
        }
        secondButton {
            flat: true
            text: qsTr("Yes")
            onClicked: {
                resetOwnServiceSettings()
                confirmPasswordAction()
                desktopMessageDialog.close()
            }
        }
    }

    function restoreSettings() {
        resetWalletAccount()
        fields.updateSettings()
    }

    function resetWalletAccount() {
        GraftClient.resetData()
        pushScreen.openCreateWalletStackViewer()
    }

    function openMnemonicScreen() {
        pushScreen.openMnemonicViewScreen(true)
    }

    function checkingPassword(password) {
        if (GraftClient.checkPassword(password)) {
            if (okMode) {
                var messageDialog = Detector.isDesktop() ? desktopMessageDialog :
                                                           mobileMessageDialog
                if (GraftClient.useOwnServiceAddress()) {
                    message = qsTr("(IP address and port of the server)")
                    messageDialog.open()
                    return
                } else if (GraftClient.useOwnUrlAddress()) {
                    message = qsTr("(URL address of the server)")
                    messageDialog.open()
                    return
                }
                if (!GraftClient.httpsType()) {
                    messageDialog.open()
                    return
                }
                fields.httpsSwitch = true
                fields.serviceAddr = false
                fields.serviceURLSwitch = false
                fields.clearField()
            }
            confirmPasswordAction()
        } else {
            screenDialog.title = qsTr("Error")
            screenDialog.text = qsTr("You enter incorrect password!\nPlease try again...")
            screenDialog.open()
        }
        passwordDialog.passwordTextField.clear()
    }

    function resetOwnServiceSettings() {
        fields.clearField()
        fields.httpsSwitch = true
        fields.serviceAddr = false
        fields.serviceURLSwitch =false
        GraftClient.removeSettings()
    }

    function save() {
        if (fields.displayCompanyName && fields.length() !== 0) {
            GraftClient.setSettings("companyName", fields.companyNameText)
        }
        GraftClient.setSettings("httpsType", fields.httpsSwitch)
        GraftClient.setSettings("useOwnServiceAddress", fields.serviceAddr)
        GraftClient.setSettings("useOwnUrlAddress", fields.serviceURLSwitch)
        if (fields.serviceAddr)
        {
            if (fields.portText !== "" && GraftClient.isValidIp(fields.ipText)) {
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
            if (GraftClient.isValidUrl(fields.addressText) && !(fields.addressText === "http://"
            || fields.addressText === "https://")) {
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
        pushScreen.openMainScreen()
        enableScreen()
    }
}
