import QtQuick 2.9
import QtQuick.Dialogs 1.2
import Qt.labs.platform 1.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import com.device.platform 1.0
import "components"

BaseScreen {
    id: root
    title: qsTr("Settings")
    action: saveChanges

    property alias companyTitle: companyNameTextField.title
    property alias ipTitle: ipTextField.title
    property alias portTitle: portTextField.title
    property alias saveButtonText: saveButton.text
    property alias displayCompanyName: companyNameTextField.visible
    property var confirmPasswordAction: null

    function saveChanges() {
        if (companyNameTextField.visible) {
            GraftClient.setSettings("companyName", companyNameTextField.text)
        }
        GraftClient.setSettings("useOwnServiceAddress", serviceAddr.checked)
        if (serviceAddr.checked) {
            if (!GraftClient.resetUrl(ipTextField.text, portTextField.text)) {
                screenDialog.text = qsTr("The service IP or port is invalid. Please, enter the " +
                                         "correct service address.")
                screenDialog.open()
                return
            }
        }
        GraftClient.saveSettings()
        pushScreen.openMainScreen()
    }

    ColumnLayout {
        spacing: 0
        anchors {
            fill: parent
            margins: 15
        }

        LinearEditItem {
            id: companyNameTextField
            maximumLength: 50
            Layout.alignment: Qt.AlignTop
            text: GraftClient.settings("companyName") ? GraftClient.settings("companyName") : ""
        }

        ColumnLayout {
            Layout.topMargin: Detector.isPlatform(Platform.IOS | Platform.Desktop) ? 9 : 0
            Layout.fillWidth: true
            spacing: 2

            Label {
                text: qsTr("Service")
                font.pixelSize: Detector.isPlatform(Platform.IOS | Platform.Desktop) ?
                                    16 : switchLabel.font.pixelSize
                color: "#8e8e93"
            }

            RowLayout {
                spacing: 0

                Label {
                    id: switchLabel
                    Layout.fillWidth: true
                    Layout.alignment: Label.AlignLeft | Label.AlignVCenter
                    text: qsTr("Use own service address")
                }

                Switch {
                    id: serviceAddr
                    Material.accent: ColorFactory.color(DesignFactory.Foreground)
                    checked: GraftClient.useOwnServiceAddress("useOwnServiceAddress")
                }
            }

            RowLayout {
                id: serviceAddrLayout
                enabled: serviceAddr.checked
                spacing: 20

                LinearEditItem {
                    id: ipTextField
                    inputMask: "000.000.000.000; "
                    inputMethodHints: Qt.ImhDigitsOnly
                    showLengthIndicator: false
                    Layout.preferredWidth: 130
                    text: GraftClient.useOwnServiceAddress("useOwnServiceAddress") ? GraftClient.settings("ip") : ""
                }

                LinearEditItem {
                    id: portTextField
                    inputMethodHints: Qt.ImhDigitsOnly
                    showLengthIndicator: false
                    Layout.preferredWidth: 100
                    text: GraftClient.useOwnServiceAddress("useOwnServiceAddress") ? GraftClient.settings("port") : ""
                    validator: RegExpValidator {
                        regExp: /\d{1,5}/
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }

        WideActionButton {
            id: resetWalletButton
            text: qsTr("Reset Account")
            onClicked: {
                confirmPasswordAction = resetWalletAccount
                passwordDialog.open()
            }
        }

        WideActionButton {
            id: mnemonicButton
            text: qsTr("Show Mnemonic Password")
            onClicked: {
                confirmPasswordAction = openMnemonicScreen
                passwordDialog.open()
            }
        }

        WideActionButton {
            id: saveButton
            Layout.alignment: Qt.AlignBottom
            onClicked: saveChanges()
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
            onClicked: passwordDialog.accept()
        }
        onAccepted: checkingPassword(passwordTextField.text)
    }

    MessageDialog {
        id: mobileMessageDialog
        title: qsTr("Attention")
        buttons: MessageDialog.Yes | MessageDialog.No
        text: qsTr("Do you want to reset the service settings?")
        detailedText: qsTr("Service settings are network-specific, if you keep them, you will " +
                           "can to create or restore account only on the same network.")

        onYesClicked: {
            resetOwnServiceSettings()
            confirmPasswordAction()
            mobileMessageDialog.close()
        }
        onNoClicked: {
            confirmPasswordAction()
            mobileMessageDialog.close()
        }
    }

    Dialog {
        id: desktopMessageDialog
        topMargin: (parent.height - desktopMessageDialog.height) / 2
        leftMargin: 25
        rightMargin: 25
        visible: false
        modal: true
        padding: 5
        contentItem: ColumnLayout {
            spacing: 10

            Label {
                id: message
                Layout.fillWidth: true
                Layout.minimumWidth: 200
                Layout.rightMargin: 20
                Layout.leftMargin: 20
                wrapMode: Text.WordWrap
                font.pixelSize: 15
                text: qsTr("Do you want to reset the service settings?")
            }

            Label {
                id: additionalMessage
                Layout.fillWidth: true
                Layout.minimumWidth: 200
                Layout.rightMargin: 20
                Layout.leftMargin: 28
                wrapMode: Text.WordWrap
                font.pixelSize: 12
                color: "#8e8e93"
                text: qsTr("Service settings are network-specific, if you keep them, you will " +
                           "can to create or restore account only on the same network.")
            }

            RowLayout {
                Layout.alignment: Qt.AlignBottom

                Item {
                    Layout.fillWidth: true
                }

                Button {
                    id: cancelButton
                    flat: true
                    text: qsTr("No")
                    onClicked: {
                        confirmPasswordAction()
                        desktopMessageDialog.close()
                    }
                }

                Button {
                    id: okButton
                    flat: true
                    text: qsTr("Yes")
                    onClicked: {
                        resetOwnServiceSettings()
                        confirmPasswordAction()
                        desktopMessageDialog.close()
                    }
                }
            }
        }
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
            var messageDialog = Detector.isDesktop() ? desktopMessageDialog : mobileMessageDialog
            messageDialog.open()
        } else {
            screenDialog.title = qsTr("Error")
            screenDialog.text = qsTr("You enter incorrect password!\nPlease try again...")
            screenDialog.open()
        }
        passwordDialog.passwordTextField.clear()
    }

    function resetOwnServiceSettings() {
        ipTextField.actionTextField.clear()
        portTextField.actionTextField.clear()
        companyNameTextField.actionTextField.clear()
        serviceAddr.checked = false
        GraftClient.removeSettings()
    }
}
