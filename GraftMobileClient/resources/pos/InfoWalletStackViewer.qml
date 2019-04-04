import QtQuick 2.9
import org.graft 1.0
import "../"

BaseStackViewer {
    id: stack
    initialItem: walletScreen
    clearStackViewer: openInfoWalletScreen

    InfoWalletScreen {
        id: walletScreen
        amountUnlockGraft: GraftClient.balance(GraftClientTools.UnlockedBalance)
        amountLockGraft: GraftClient.balance(GraftClientTools.LockedBalance)
        pushScreen: walletTransitions()
    }

    function walletTransitions() {
        var transitionsMap = pushScreen
        transitionsMap["openAddAccountScreen"] = openAddAccountScreen
        transitionsMap["openMainAddressScreen"] = openMainAddressScreen
        transitionsMap["openInfoWalletScreen"] = openInfoWalletScreen
        transitionsMap["openAddressScreen"] = openAddressScreen
        transitionsMap["goBack"] = goBack
        return transitionsMap
    }

    function openAddAccountScreen() {
        stack.push("qrc:/AddAccountScreen.qml", {"pushScreen": walletTransitions(),
                   "coinModel": CoinModel})
    }

    function openMainAddressScreen() {
        stack.push("qrc:/WalletAddressScreen.qml", {"pushScreen": walletTransitions()})
    }

    function openAddressScreen(balance, accountName, imagePath, accountNumber, type) {
        stack.push("qrc:/WalletAddressScreen.qml", {"pushScreen": walletTransitions(),
                   "accountBalance": balance, "accountName": accountName, "accountImage": imagePath,
                   "balanceState": "coinsAddress", "accountNumber": accountNumber, "accountType": type})
    }

    function openInfoWalletScreen() {
        stack.pop(walletScreen)
    }
}
