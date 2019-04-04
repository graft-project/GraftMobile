import QtQuick 2.9
import QtQuick.Layouts 1.3
import org.graft 1.0
import "../"
import "../components"

BaseBalanceScreen {

    Connections {
        target: GraftClient

        onNetworkTypeChanged: {
            payButton.enabled = GraftClient.networkType() === GraftClientTools.PublicExperimentalTestnet
        }
    }

    ColumnLayout {
        spacing: 0
        anchors.fill: parent

        CoinListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        AddNewButton {
            buttonTitle: qsTr("Add new account")
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            Layout.bottomMargin: 15
            topLine: true
            bottomLine: true
            visible: false
            onClicked: pushScreen.openAddAccountScreen()
        }

        WideActionButton {
            id: sendCoinsButton
            Layout.fillWidth: true
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            Layout.alignment: Qt.AlignCenter
            text: qsTr("Send")
            onClicked: {
                disableScreen()
                pushScreen.openSendCoinScreen()
            }
        }

        WideActionButton {
            id: payButton
            Layout.fillWidth: true
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            Layout.bottomMargin: 15
            Layout.alignment: Qt.AlignCenter
            text: qsTr("Pay")
            enabled: GraftClient.networkType() === GraftClientTools.PublicExperimentalTestnet
            onClicked: {
                disableScreen()
                pushScreen.openQRCodeScanner()
            }
        }
    }
}
