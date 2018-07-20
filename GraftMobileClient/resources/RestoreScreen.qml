import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.device.platform 1.0
import "components"

BaseScreen {
    id: root
    title: qsTr("Restore wallet")
    action: restoreWallet
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
            bottomMargin: Detector.detectDevice() === Platform.IPhoneX ? 30 : 15
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
                regExp: /([a-z]+\s+){24}([a-z]+){1}/g
            }
            inputMethodHints: Qt.ImhLowercaseOnly | Qt.ImhNoPredictiveText
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
            Layout.alignment: Qt.AlignBottom
            text: qsTr("Restore")
            onClicked: {
                var checkDialog = Detector.isDesktop() ? dialogs.desktopMessageDialog : dialogs.mobileMessageDialog
                if (!passwordTextField.wrongPassword) {
                    if (passwordTextField.passwordText === "" && passwordTextField.confirmPasswordText === "") {
                        checkDialog.open()
                        return
                    }
                    restoreWallet()
                }
            }
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
        desktopConfirmButton.onClicked: restoreWallet()
    }

    function restoreWallet() {
        if (GraftClient.wideSpacingSimplify(seedTextField.text).split(' ').length < 25) {
            screenDialog.text = seedTextField.text.length === 0 ?
                        qsTr("The mnemonic phrase is empty.\nPlease, enter the mnemonic phrase.") :
                        qsTr("The mnemonic phrase must contain 25 words. Please, enter " +
                             "the correct mnemonic phrase.")
            screenDialog.open()
        } else {
            disableScreen()
            busyIndicator.running = true
            GraftClient.restoreAccount(GraftClient.wideSpacingSimplify(seedTextField.text),
                                       passwordTextField.passwordText)
        }
    }
}
