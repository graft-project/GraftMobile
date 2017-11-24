import QtQuick 2.9
import QtQuick.Layouts 1.3
import org.graft 1.0

ListView {
    id: accountListView
    model: AccountModel
    clip: true
    spacing: 0
    delegate: CoinAccountDelegate {
        bottomLineVisible: index === (accountListView.count - 1)
        width: accountListView.width
        productImage: imagePath
        accountTitle: accountName
        accountBalance: GraftClient.balance(GraftClientTools.UnlockedBalance)
    }
}
