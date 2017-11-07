import QtQuick 2.9
import QtQuick.Layouts 1.3
import "../"
import "../components"

BaseBalanceScreen {
    id: balanceScreen

    ColumnLayout {
        spacing: 0
        anchors {
            fill: parent
            leftMargin: 15
            rightMargin: 15
        }

        ListView {
            id: accountListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: AccountModel
            clip: true
            spacing: 0
            delegate: CoinAccountDelegate {
                bottomLineVisible: index === (accountListView.count - 1)
                width: accountListView.width
                height: accountListView.width / 5 - 10
                productImage: imagePath
                accountTitle: accountName
                accountBalance: balance
            }
        }

        AddNewButton {
            buttonTitle: qsTr("Add new account")
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            Layout.leftMargin: 4
            Layout.rightMargin: 4
            Layout.bottomMargin: 15
            topLine: true
            bottomLine: true
            onClicked: pushScreen.openAddAccountScreen()
        }

        WideActionButton {
            text: qsTr("PAY")
            Layout.bottomMargin: 15
            onClicked: pushScreen.openQRCodeScanner()
        }
    }
}