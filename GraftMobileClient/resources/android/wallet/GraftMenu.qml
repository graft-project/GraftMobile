import QtQuick 2.9
import QtQuick.Layouts 1.3
import com.graft.design 1.0
import org.graft 1.0
import "../components"
import "../"

BaseMenu {
    property alias balanceInGraft: walletItem.balanceInGraft

    logo: "qrc:/imgs/graft_wallet_logo_small.png"

    Connections {
        target: GraftClient
        onBalanceUpdated: {
            walletItem.balanceInGraft = GraftClient.balance(GraftClientTools.UnlockedBalance)
        }
    }

    ColumnLayout {
        spacing: 0
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        MenuWalletItem {
            id: walletItem
            Layout.fillWidth: true
            onClicked: {
                pushScreen.hideMenu()
                pushScreen.openMainScreen()
            }
        }

        MenuLabelItem {
            id: transactionItem
            Layout.fillWidth: true
            icon: "qrc:/imgs/transaction.png"
            name: qsTr("Transaction")
            enabled: false
            opacity: 0.2
            onClicked: {
                pushScreen.hideMenu()
                pushScreen.openTransactionScreen()
            }
        }

        MenuLabelItem {
            id: transferItem
            Layout.fillWidth: true
            icon: "qrc:/imgs/transfer.png"
            name: qsTr("Transfer")
            enabled: false
            opacity: 0.2
            onClicked: {
                pushScreen.hideMenu()
                pushScreen.openTransferScreen()
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.topMargin: 10
            Layout.bottomMargin: 10
            Layout.preferredHeight: 1.5
            Layout.alignment: Qt.AlignBottom
            color: ColorFactory.color(DesignFactory.AllocateLine)
        }

        MenuLabelItem {
            Layout.fillWidth: true
            icon: "qrc:/imgs/settings.png"
            name: qsTr("Settings")
            onClicked: {
                pushScreen.hideMenu()
                pushScreen.openSettingsScreen()
            }
        }

        MenuLabelItem {
            Layout.fillWidth: true
            icon: "qrc:/imgs/info.png"
            name: qsTr("About")
            onClicked: {
                pushScreen.hideMenu()
                Qt.openUrlExternally("https://www.graft.network/")
            }
        }
    }
}
