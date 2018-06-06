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
    property alias addressTitle: addressTextField.title
    property alias saveButtonText: saveButton.text
    property alias displayCompanyName: companyNameTextField.visible
    property var confirmPasswordAction: null
    property string message: ""
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
                    Layout.fillWidth: true
                    Layout.alignment: Label.AlignLeft | Label.AlignVCenter
                    text: qsTr("Enable HTTPS")
                }

                Switch {
                    id: httpsSwitch
                    Layout.topMargin: 5
                    checked: GraftClient.httpsType()
                    Material.accent: ColorFactory.color(DesignFactory.Foreground)
                    onCheckedChanged: {
                        replaceNetworkType(addressTextField.text)
                        if (serviceAddr.checked) {
                            addressFieldFocus()
                        } else if (serviceURLSwitch.checked) {
                            urlFieldFocus()
                        }
                    }
                }
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
                    onCheckedChanged: {
                        if (serviceAddr.checked) {
                            serviceURLSwitch.checked = false
                            addressFieldFocus()
                        }
                    }
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
                state: "hidden"
                states: [
                    State {
                        name: "hidden"
                        when: !serviceAddr.checked
                        PropertyChanges {
                            target: serviceAddrLayout
                            visible: false
                            opacity: 0
                        }
                    }
                ]
                transitions: Transition {
                    PropertyAnimation {
                        property: "opacity"
                        duration: 800
                    }
                }

                LinearEditItem {
                    id: ipTextField
                    inputMask: "000.000.000.000; "
                    inputMethodHints: Qt.ImhDigitsOnly
                    showLengthIndicator: false
                    Layout.preferredWidth: 130
                    fieldCursorPosition: 0
                    text: GraftClient.useOwnServiceAddress() ? GraftClient.settings("ip") : ""
                }

                LinearEditItem {
                    id: portTextField
                    inputMethodHints: Qt.ImhDigitsOnly
                    showLengthIndicator: false
                    Layout.preferredWidth: 100
                    text: GraftClient.useOwnServiceAddress() ? GraftClient.settings("port") : ""
                    validator: RegExpValidator {
                        regExp: /\d{1,5}/
                    }
                }
            }

            RowLayout {
                spacing: 0

                Label {
                    id: serviceURLLabel
                    Layout.fillWidth: true
                    Layout.alignment: Label.AlignLeft | Label.AlignVCenter
                    text: qsTr("Use own service URL")
                }

                Switch {
                    id: serviceURLSwitch
                    Material.accent: ColorFactory.color(DesignFactory.Foreground)
                    checked: GraftClient.urlAddress()
                    onCheckedChanged: {
                        replaceNetworkType(addressTextField.text)
                        if (serviceURLSwitch.checked) {
                            serviceAddr.checked = false
                            urlFieldFocus()
                        }
                    }
                }
            }

            LinearEditItem {
                id: addressTextField
                enabled: serviceURLSwitch.checked
                inputMethodHints: Qt.ImhHiddenText
                Layout.alignment: Qt.AlignTop
                text: GraftClient.urlAddress() ? GraftClient.settings("address") : "http://"
                showLengthIndicator: false
                onUpdateText: replaceNetworkType(addressTextField.text)
                state: "hidden"
                states: [
                    State {
                        name: "hidden"
                        when: !serviceURLSwitch.checked
                        PropertyChanges {
                            target: addressTextField
                            visible: false
                            opacity: 0
                        }
                    }
                ]
                transitions: Transition {
                    PropertyAnimation {
                        property: "opacity"
                        duration: 800
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
        if (GraftClient.useOwnServiceAddress()) {
            ipTextField.text = GraftClient.settings("ip")
            portTextField.text = GraftClient.settings("port")
        }
        if (GraftClient.urlAddress()) {
            addressTextField.text = GraftClient.settings("address")
        }
        if (!GraftClient.httpsType()) {
            httpsSwitch.checked = GraftClient.settings("httpsType")
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
            if (okMode) {
                var messageDialog = Detector.isDesktop() ? desktopMessageDialog :
                                                           mobileMessageDialog
                if (GraftClient.useOwnServiceAddress()) {
                    message = qsTr("(IP address and port of the server)")
                    messageDialog.open()
                    return
                } else if (GraftClient.urlAddress()) {
                    message = qsTr("(URL address of the server)")
                    messageDialog.open()
                    return
                }
                if (!GraftClient.httpsType()) {
                    messageDialog.open()
                    return
                }
                httpsSwitch.checked = true
                serviceAddr.checked = false
                serviceURLSwitch.checked = false
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
        ipTextField.actionTextField.clear()
        portTextField.actionTextField.clear()
        addressTextField.actionTextField.clear()
        companyNameTextField.actionTextField.clear()
        httpsSwitch.checked = true
        serviceAddr.checked = false
        serviceURLSwitch.checked =false
        GraftClient.removeSettings()
    }

    function saveChanges() {
        GraftClient.setSettings("httpsType", httpsSwitch.checked)
        if (companyNameTextField.visible) {
            GraftClient.setSettings("companyName", companyNameTextField.text)
        }
        if (portTextField.text !== "" && GraftClient.isValidIp(ipTextField.text)) {
            GraftClient.setSettings("useOwnServiceAddress", serviceAddr.checked)
        }
        if (GraftClient.isValidUrl(addressTextField.text) && !(addressTextField.text === "http://"
        || addressTextField.text === "https://")) {
            GraftClient.setSettings("urlAddress", serviceURLSwitch.checked)
        }
        if (serviceURLSwitch.checked) {
            if (!GraftClient.resetUrlAddress(addressTextField.text)) {
                screenDialog.text = qsTr("The service URL is invalid. Please, enter the " +
                                         "correct service address.")
                screenDialog.open()
                enableScreen()
                return
            }
        } else if (serviceAddr.checked) {
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

    function replaceNetworkType(text) {
        var regExp = text.match(new RegExp(/^https?:\/\//g))
        if (regExp !== null) {
            if (regExp.toString() === "https://" && !httpsSwitch.checked) {
                addressTextField.text = text.replace(/https/i, "http")
            } else if (regExp.toString() === "http://" && httpsSwitch.checked) {
                addressTextField.text = text.replace(/http/i, "https")
            }
        } else {
            if (!httpsSwitch.checked) {
                addressTextField.text = ("http://")
            } else {
                addressTextField.text = ("https://")
            }
        }
    }

    function addressFieldFocus() {
        if (ipTextField.text.length === 3) {
            ipTextField.inFocus = serviceAddr.checked
        } else if (portTextField.text.length === 0) {
            portTextField.inFocus = serviceAddr.checked
        } else {
            ipTextField.inFocus = false
            portTextField.inFocus = false
        }
    }

    function urlFieldFocus() {
        if (httpsSwitch.checked) {
            addressTextField.inFocus = addressTextField.text.length < 9 ?
                                       serviceURLSwitch.checked : false
        } else {
            addressTextField.inFocus = addressTextField.text.length < 8 ?
                                       serviceURLSwitch.checked : false
        }
    }
}
