import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import "components"

BaseScreen {
    id: root

    title: qsTr("Create wallet")
    screenHeader {
        isNavigationButtonVisible: false
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
        }

        WideActionButton {
            id: createWalletButton
            Layout.bottomMargin: 15
            text: qsTr("Create New Wallet")
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
                text: qsTr("Restor wallet from mnemonic phrase")
            }
        }

        WideActionButton {
            id: restoreWalletButton
            Layout.alignment: Qt.AlignBottom
            Layout.bottomMargin: 15
            text: qsTr("Restore Wallet")
        }
    }
}
