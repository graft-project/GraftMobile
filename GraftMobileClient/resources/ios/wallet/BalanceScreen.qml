import QtQuick 2.9
import QtQuick.Layouts 1.3
import "../"
import "../components"
import org.graft 1.0

BaseBalanceScreen {
    id: balanceScreen
    screenHeader.navigationButtonState: false

    Connections {
        target: GraftClient

        onNetworkTypeChanged: {
            payButton.enabled = GraftClient.networkType()
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
            onClicked: pushScreen.openAddAccountScreen()
        }

        WideActionButton {
            id: payButton
            text: qsTr("PAY")
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            Layout.bottomMargin: 15
            enabled: GraftClient.networkType() === GraftClientTools.PublicExperimentalTestnet
            onClicked: pushScreen.openQRCodeScanner()
        }
    }
}
