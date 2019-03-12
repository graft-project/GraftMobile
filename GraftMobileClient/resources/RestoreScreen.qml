import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.device.platform 1.0
import org.navigation.attached.properties 1.0
import org.graft 1.0
import "components"

BaseScreen {
    id: root
    title: qsTr("Restore wallet")
    action: validatePassword
    screenHeader.actionButtonState: true
    onErrorMessage: busyIndicator.running = false

    Component.onCompleted: {
        if (Detector.isPlatform(Platform.IOS)) {
            navigationText: qsTr("Cancel")
            actionText: qsTr("Restore")
        }
    }

    Connections {
        target: GraftClient

        onRestoreAccountReceived: {
            if (isAccountRestored) {
                pushScreen.openBaseScreen()
            } else {
                busyIndicator.running = false
                enableScreen()
            }
        }
    }

    ColumnLayout {
        spacing: 3
        anchors {
            fill: parent
            topMargin: 15
            leftMargin: 15
            rightMargin: 15
            bottomMargin: Detector.bottomNavigationBarHeight() + 15
        }

        LinearEditItem {
            id: seedTextField
            Layout.fillWidth: true
            Layout.maximumHeight: Detector.isPlatform(Platform.IOS | Platform.Desktop) ? 160 : 135
            Layout.alignment: Qt.AlignTop
            title: qsTr("Mnemonic Phrase")
            wrapMode: TextInput.WordWrap
            letterCountingMode: false
            maximumLength: 25
            validator: RegExpValidator {
                regExp: /([a-zA-Z]+\s+){24}([a-zA-Z]+){1}/g
            }
            inputMethodHints: Qt.ImhLowercaseOnly | Qt.ImhNoPredictiveText
            Component.onCompleted: {
                if (Detector.isPlatform(Platform.IOS)) {
                    echoMode = TextInput.Password
                }
            }
            onTextChanged: {
                if (Detector.isPlatform(Platform.IOS) && seedTextField.echoMode !== TextInput.Normal) {
                    echoMode = TextInput.Normal
                }
            }
        }

        PasswordFields {
            id: passwordTextField
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        WideActionButton {
            id: restoreWalletButton
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignBottom | Qt.AlignCenter
            text: qsTr("Restore")
            KeyNavigation.tab: root.Navigation.implicitFirstComponent
            onClicked: validatePassword()
        }
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: false
    }

    ValidPasswordMessageDialog {
        id: dialogs
        mobileMessageDialog.onYes: restoreWallet()
        onDesktopDialogApproved: restoreWallet()
    }

    function validatePassword() {
        var checkDialog = Detector.isDesktop() ? dialogs.desktopMessageDialog :
                                                 dialogs.mobileMessageDialog
        if (!passwordTextField.wrongPassword) {
            if (passwordTextField.passwordText === "" &&
                passwordTextField.confirmPasswordText === "") {
                checkDialog.open()
                return
            }
            restoreWallet()
        }
    }

    function restoreWallet() {
        if (GraftClientTools.wideSpacingSimplify(seedTextField.text).split(' ').length < 25) {
            screenDialog.text = seedTextField.text.length === 0 ?
                        qsTr("The mnemonic phrase is empty.\nPlease, enter the mnemonic phrase.") :
                        qsTr("The mnemonic phrase must contain 25 words. Please, enter " +
                             "the correct mnemonic phrase.")
            screenDialog.open()
        } else {
            disableScreen()
            busyIndicator.running = true
            GraftClient.restoreAccount(GraftClientTools.wideSpacingSimplify(seedTextField.text),
                                       passwordTextField.passwordText)
        }
    }
}
