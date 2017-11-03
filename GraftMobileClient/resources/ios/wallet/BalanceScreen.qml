import QtQuick 2.9
import QtQuick.Layouts 1.3
import "../"
import "../components"

BaseBalanceScreen {
    id: balanceScreen

    property real balance: 0

    screenHeader {
        navigationButtonState: false
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

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
                accountTitle: accountName
                productImage: imagePath
                accountBalance: balance
            }
        }

        AddNewButton {
            buttonTitle: qsTr("Add new account")
            Layout.preferredHeight: 60
            Layout.leftMargin: 4
            Layout.rightMargin: 4
            Layout.bottomMargin: 15
            Layout.fillWidth: true
            onClicked: pushScreen.openAddAccountScreen()
        }

        WideActionButton {
            text: qsTr("PAY")
            Layout.bottomMargin: 15
            onPressed: pushScreen.openQRCodeScanner()
        }
    }
}
