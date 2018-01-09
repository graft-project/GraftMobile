import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import "components"

BaseScreen {
    id: root
    title: qsTr("Create wallet")

    Connections {
        target: GraftClient

        onCreateAccountReceived: {
            pushScreen.openMnemonicViewScreen(false)
        }
    }

    ColumnLayout {
        anchors {
            fill: parent
            leftMargin: 10
            rightMargin: 10
        }

        LinearEditItem {
            id: passwordTextField
            Layout.alignment: Qt.AlignTop
            Layout.topMargin: 10
            maximumLength: 50
            title: Qt.platform.os === "android" ? qsTr("Password") : qsTr("Password:")
            echoMode: TextInput.Password
            passwordCharacter: '•'
        }

        WideActionButton {
            id: createWalletButton
            Layout.bottomMargin: 15
            text: qsTr("Create New Wallet")
            onClicked: {
                root.state = "createWalletPressed"
                GraftClient.createAccount(passwordTextField.text)
            }
        }

        Item {
            Layout.fillHeight: true
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
            Layout.bottomMargin: 15
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
        }
    ]
}
