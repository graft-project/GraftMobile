import QtQuick 2.9
import QtQuick.Layouts 1.3
import "../components"

BaseMenu {
    property alias balanceInGraft: walletItem.balanceInGraft

    logo: "qrc:/imgs/graft_wallet_logo_small.png"

    ColumnLayout {
        spacing: 0
        anchors {
            left: parent.left
            right: parent.right
        }

        MenuLabelItem {
            Layout.fillWidth: true
            icon: "qrc:/imgs/home.png"
            name: qsTr("Home")
            onClicked: {
                pushScreen.hideMenu()
                pushScreen.openBalanceScreen()
            }
        }

        MenuWalletItem {
            id: walletItem
            Layout.fillWidth: true
            onClicked: {
                pushScreen.hideMenu()
                pushScreen.openWalletScreen()
            }
        }

        MenuLabelItem {
            Layout.fillWidth: true
            icon: "qrc:/imgs/transaction.png"
            name: qsTr("Transaction")
            onClicked: {
                pushScreen.hideMenu()
                pushScreen.openTransactionScreen()
            }
        }

        MenuLabelItem {
            Layout.fillWidth: true
            icon: "qrc:/imgs/transfer.png"
            name: qsTr("Transfer")
            onClicked: {
                pushScreen.hideMenu()
                pushScreen.openTransferScreen()
            }
        }
    }
}
