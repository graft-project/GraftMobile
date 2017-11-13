import QtQuick 2.9
import QtQuick.Layouts 1.3
import "../"
import "../components"

BaseBalanceScreen {
    id: infoWallet
    graftWalletLogo: "qrc:/imgs/graft-pos-logo.png"
    screenHeader {
        navigationButtonState: Qt.platform.os === "android"
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
            onClicked: pushScreen.openAddAccountScreen()
        }

        WideActionButton {
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            Layout.alignment: Qt.AlignBottom
            text: qsTr("Transfer to Paypal")
        }

        WideActionButton {
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            Layout.bottomMargin: 15
            Layout.alignment: Qt.AlignBottom
            text: qsTr("Chase XXX929")
        }
    }
}
