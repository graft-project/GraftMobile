import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.device.detector 1.0
import "components"

BaseScreen {
    id: root
    title: qsTr("Create wallet")
    screenHeader.navigationButtonState: Qt.platform.os === "ios"

    Connections {
        target: GraftClient

        onCreateAccountReceived: {
            if (isAccountCreated) {
                pushScreen.openMnemonicViewScreen(false)
            } else {
                root.state = "accountNotExist"
            }
        }
    }

    ColumnLayout {
        spacing: 15
        anchors {
            fill: parent
            topMargin: 15
            leftMargin: 15
            rightMargin: 15
            bottomMargin: Device.detectDevice() === DeviceDetector.IPhoneX ? 30 : 15
        }

        PasswordFields {
            id: passwordTextField
        }

        WideActionButton {
            id: createWalletButton
            text: qsTr("Create New Wallet")
            onClicked: {
                if (!passwordTextField.comparePassword(passwordTextField.passwordText, passwordTextField.confirmPasswordText)) {
                    root.state = "createWalletPressed"
                    GraftClient.createAccount(passwordTextField.passwordText)
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
                    pointSize: 18
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
            text: qsTr("Restore Wallet")
            onClicked: pushScreen.openRestoreWalletScreen()
        }
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: false
    }

    states: [
        State {
            name: "createWalletPressed"

            PropertyChanges {
                target: busyIndicator
                running: true
            }
            PropertyChanges {
                target: root
                enabled: false
            }
        },
        State {
            name: "accountNotExist"

            PropertyChanges {
                target: busyIndicator
                running: false
            }
            PropertyChanges {
                target: root
                enabled: true
            }
        }
    ]
}
