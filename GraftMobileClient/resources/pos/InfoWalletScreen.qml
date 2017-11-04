import QtQuick 2.9
import QtQuick.Layouts 1.3
import "../"
import "../components"

BaseBalanceScreen {
    id: infoWallet
    splitterVisible: false
    graftWalletLogo: "qrc:/imgs/graft-pos-logo.png"
    screenHeader {
        navigationButtonState: Qt.platform.os === "android"
    }

    ColumnLayout {

        spacing: 0
        anchors {
            fill: parent
            leftMargin: 15
            rightMargin: 15
            bottomMargin: 15
        }

        WideActionButton {
            Layout.topMargin: infoWallet.height / 2 - 100
            Layout.alignment: Qt.AlignBottom
            text: qsTr("Transfer to Paypal")
        }

        WideActionButton {
            Layout.alignment: Qt.AlignBottom
            text: qsTr("Chase XXX929")
        }
    }
}
