import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import com.device.platform 1.0
import "components"

BaseScreen {
    id: root
    title: qsTr("Create wallet")
    screenHeader {
        actionButtonState: true
        isSettings: true
    }
    action: pushSettingsScreen

    onErrorMessage: busyIndicator.running = false

    Component.onCompleted: {
        if (Detector.isPlatform(Platform.IOS | Platform.Desktop)) {
            screenHeader.actionText = qsTr("Settings")
        }
    }

    Connections {
        target: GraftClient

        onCreateAccountReceived: {
            if (isAccountCreated) {
                pushScreen.openMnemonicViewScreen(false)
            } else {
                busyIndicator.running = false
                enableScreen()
            }
        }
    }

    ColumnLayout {
        spacing: Detector.isPlatform(Platform.Desktop) ? 5 : 15
        anchors {
            fill: parent
            topMargin: 15
            leftMargin: 15
            rightMargin: 15
            bottomMargin: Detector.detectDevice() === Platform.IPhoneX ? 30 : 15
        }

        PasswordFields {
            id: passwordTextField
        }

        WideActionButton {
            id: createWalletButton
            Layout.topMargin: Detector.isPlatform(Platform.Desktop) ? 15 : 0
            text: qsTr("Create New Wallet")
            onClicked: {
                var checkDialog = Detector.isDesktop() ? dialogs.desktopMessageDialog :
                                                         dialogs.mobileMessageDialog
                if (!passwordTextField.wrongPassword) {
                    if (passwordTextField.passwordText === "" &&
                            passwordTextField.confirmPasswordText === "") {
                        checkDialog.open()
                        return
                    }
                    createAccount()
                }
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            Label {
                Layout.fillWidth: true
                horizontalAlignment: Label.AlignHCenter
                font {
                    bold: true
                    pixelSize: 18
                }
                color: "#BBBBBB"
                text: qsTr("If you have one")
            }

            Label {
                Layout.fillWidth: true
                horizontalAlignment: Label.AlignHCenter
                color: "#BBBBBB"
                text: qsTr("Restore wallet from mnemonic phrase")
            }
        }

        WideActionButton {
            id: restoreWalletButton
            Layout.alignment: Qt.AlignBottom
            text: qsTr("Restore/Import Wallet")
            onClicked: {
                disableScreen()
                pushScreen.openRestoreWalletScreen()
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
        mobileMessageDialog.onYes: createAccount()
        onDesktopDialogApproved: createAccount()
    }

    function createAccount() {
        dialogs.desktopMessageDialog.confirmButtonEnabled = false
        disableScreen()
        busyIndicator.running = true
        GraftClient.createAccount(passwordTextField.passwordText)
        dialogs.desktopMessageDialog.confirmButtonEnabled = true
    }

    function pushSettingsScreen() {
        pushScreen.serviceSettingsScreen()
    }
}
