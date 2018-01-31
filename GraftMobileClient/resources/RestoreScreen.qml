import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.device.detector 1.0
import "components"

BaseScreen {
    id: root
    title: qsTr("Restore wallet")
    action: restoreWallet
    screenHeader {
        navigationButtonState: Qt.platform.os === "ios"
        actionButtonState: true
    }

    Component.onCompleted: {
        if (Qt.platform.os === "ios") {
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
                root.state = "accountNotRestored"
            }
        }
    }

    ColumnLayout {
        spacing: 0
        anchors {
            fill: parent
            topMargin: 15
            leftMargin: 15
            rightMargin: 15
            bottomMargin: Device.detectDevice() === DeviceDetector.IPhoneX ? 30 : 15
        }

        LinearEditItem {
            id: seedTextField
            Layout.fillWidth: true
            Layout.maximumHeight: Qt.platform.os === "ios" ? 160 : 130
            Layout.alignment: Qt.AlignTop
            title: qsTr("Mnemonic Phrase")
            wrapMode: TextInput.WordWrap
            letterCountingMode: false
            maximumLength: 25
            validator: RegExpValidator {
                regExp: /([a-z]+\s+){24}([a-z]+){1}/g
            }
            inputMethodHints: Qt.ImhNoPredictiveText
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
                if (!passwordTextField.wrongPassword) {
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

    states: [
        State {
            name: "restoreWalletPressed"

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
            name: "accountNotRestored"

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

    function restoreWallet() {
        if (GraftClient.wideSpacingSimplify(seedTextField.text).split(' ').length < 25) {
            screenDialog.text = seedTextField.text.length === 0 ?
                        qsTr("The mnemonic phrase is empty.\nPlease, enter the mnemonic phrase.") :
                        qsTr("The mnemonic phrase must contain 25 words. Please, enter " +
                             "the correct mnemonic phrase.")
            screenDialog.open()
        } else {
            root.state = "restoreWalletPressed"
            GraftClient.restoreAccount(GraftClient.wideSpacingSimplify(seedTextField.text),
                                       passwordTextField.text)
        }
    }
}
