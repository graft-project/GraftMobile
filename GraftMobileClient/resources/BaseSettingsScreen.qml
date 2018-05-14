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
    action: saveChanges

    property alias companyTitle: companyNameTextField.title
    property alias ipTitle: ipTextField.title
    property alias portTitle: portTextField.title
    property alias saveButtonText: saveButton.text
    property alias displayCompanyName: companyNameTextField.visible
    property var confirmPasswordAction: null
    property bool okMode: false

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
                    checked: GraftClient.useOwnServiceAddress()
                }
            }

            RowLayout {
                id: serviceAddrLayout
                enabled: serviceAddr.checked
                anchors {
                    right: parent.right
                    left: parent.left
                }
                spacing: 20

                LinearEditItem {
                    id: ipTextField
                    inputMask: "000.000.000.000; "
                    inputMethodHints: Qt.ImhDigitsOnly
                    showLengthIndicator: false
                    Layout.preferredWidth: 130
                    inFocus: serviceAddr.checked
                    text: GraftClient.useOwnServiceAddress() ? GraftClient.settings("ip") : ""
                }

                LinearEditItem {
                    id: portTextField
                    inputMethodHints: Qt.ImhDigitsOnly
                    showLengthIndicator: false
                    Layout.preferredWidth: 100
                    inFocus: serviceAddr.checked
                    text: GraftClient.useOwnServiceAddress() ? GraftClient.settings("port") : ""
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
                saveChanges()
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
        text: qsTr("Would you like to reset the service settings (IP address and port of the server)?")
        onYes: {
            resetOwnServiceSettings()
            confirmPasswordAction()
            mobileMessageDialog.close()
        }
        onNo: {
            validateSettings()
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
        messageTitle: qsTr("Would you like to reset the service settings (IP address and port of the server)?")
        firstButton {
            flat: true
            text: qsTr("No")
            onClicked: {
                validateSettings()
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

    function validateSettings() {
        if (portTextField.text === "" || !GraftClient.isValidIp(ipTextField.text)) {
            if (serviceAddr.checked) {
                ipTextField.text = GraftClient.settings("ip")
                portTextField.text = GraftClient.settings("port")
            } else {
                resetOwnServiceSettings()
            }
        }
        confirmPasswordAction()
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
            if (okMode && serviceAddr.checked) {
                var messageDialog = Detector.isDesktop() ? desktopMessageDialog : mobileMessageDialog
                messageDialog.open()
            } else {
                confirmPasswordAction()
            }
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

    function saveChanges() {
        if (companyNameTextField.visible) {
            GraftClient.setSettings("companyName", companyNameTextField.text)
        }
        if (portTextField.text !== "" && GraftClient.isValidIp(ipTextField.text)) {
            GraftClient.setSettings("useOwnServiceAddress", serviceAddr.checked)
        }
        if (serviceAddr.checked) {
            if (!GraftClient.resetUrl(ipTextField.text, portTextField.text)) {
                screenDialog.text = qsTr("The service IP or port is invalid. Please, enter the " +
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
