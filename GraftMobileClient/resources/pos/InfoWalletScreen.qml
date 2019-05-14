import QtQuick 2.9
import QtQuick.Layouts 1.3
import org.navigation.attached.properties 1.0
import "../"
import "../components"

BaseBalanceScreen {
    id: infoWallet
    graftWalletLogo: "qrc:/imgs/graft-pos-logo.png"
    Navigation.explicitLastComponent: unlockedBalanceBacktabID()

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
            id: transferButton
            Layout.fillWidth: true
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            Layout.alignment: Qt.AlignBottom | Qt.AlignCenter
            KeyNavigation.tab: chaseButton.enabled ? null : infoWallet.Navigation.implicitFirstComponent
            enabled: false
            text: qsTr("Transfer to Paypal")
        }

        WideActionButton {
            id: chaseButton
            Layout.fillWidth: true
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            Layout.bottomMargin: 15
            Layout.alignment: Qt.AlignBottom | Qt.AlignCenter
            KeyNavigation.tab: infoWallet.Navigation.implicitFirstComponent
            enabled: false
            text: qsTr("Chase XXX929")
        }
    }

    function unlockedBalanceBacktabID() {
        if (!chaseButton.enabled && !transferButton.enabled) {
            return infoWallet.Navigation.implicitLastComponent
        } else {
            return chaseButton.enabled ? chaseButton : transferButton
        }
    }
}
