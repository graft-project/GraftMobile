import QtQuick 2.9
import QtQuick.Layouts 1.3
import org.graft 1.0
import org.navigation.attached.properties 1.0
import "../"
import "../components"

BaseBalanceScreen {
    id: baseBalanceScreen
    Navigation.explicitLastComponent: payButton.enabled ? payButton : sendCoinsButton

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
            visible: false
            onClicked: pushScreen.openAddAccountScreen()
        }

        WideActionButton {
            id: sendCoinsButton
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            text: qsTr("Send")
            KeyNavigation.tab: payButton.enabled ? null : baseBalanceScreen.Navigation.implicitFirstComponent
            onClicked: {
                disableScreen()
                pushScreen.openSendCoinScreen()
            }
        }

        WideActionButton {
            id: payButton
            text: qsTr("Pay")
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            Layout.bottomMargin: 15
            enabled: GraftClient.networkType() === GraftClientTools.PublicExperimentalTestnet
            KeyNavigation.tab: baseBalanceScreen.Navigation.implicitFirstComponent
            onClicked: {
                disableScreen()
                pushScreen.openQRCodeScanner()
            }
        }
    }
}
