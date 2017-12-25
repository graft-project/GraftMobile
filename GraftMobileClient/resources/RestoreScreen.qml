import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import "components"

BaseScreen {
    title: qsTr("Restore wallet")
    action: restoreWallet
    screenHeader {
        navigationButtonState: Qt.platform.os === "ios"
        actionButtonState: true
    }

    Component.onCompleted: {
        if (Qt.platform.os === "ios") {
            navigationText: qsTr("Cancel")
            actionText: qsTr("Done")
        }
    }

    Connections {
        target: GraftClient

        onRestoreAccountReceived: {
            pushScreen.openMainScreen()
        }
    }

    ColumnLayout {
        anchors {
            fill: parent
            margins: 15
        }

        LinearEditItem {
            id: seedTextField
            Layout.fillWidth: true
            Layout.maximumHeight: 100
            Layout.alignment: Qt.AlignTop
            title: qsTr("Mnemonic Phrase")
            wrapMode: TextInput.WordWrap
            letterCountingMode: false
            maximumLength: 25
            validator: RegExpValidator {
                regExp: /(\w+ ){24}(\w+){1}/g
            }
        }

        LinearEditItem {
            id: passwordTextField
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            title: Qt.platform.os === "ios" ? qsTr("Password:") : qsTr("Password")
            maximumLength: 50
            echoMode: TextInput.Password
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        WideActionButton {
            Layout.alignment: Qt.AlignBottom
            text: qsTr("Restore wallet")
            onClicked: restoreWallet()
        }
    }

    function restoreWallet() {
        GraftClient.restoreAccount(seedTextField.text, passwordTextField.text)
    }
}
