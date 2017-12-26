import QtQuick 2.0
import org.graft 1.0
import "../"

BaseStackViewer {
    id: stack
    initialItem: walletScreen

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
        transitionsMap["openAddressScreen"] = openAddressScreen
        transitionsMap["goBack"] = goBack
        return transitionsMap
    }

    function openAddAccountScreen() {
        stack.push("qrc:/AddAccountScreen.qml", {"pushScreen": walletTransitions(),
                   "coinModel": CoinModel})
    }

    function openMainAddressScreen(balanceState) {
        stack.push("qrc:/WalletAddressScreen.qml", {"pushScreen": walletTransitions(),
                       "balanceState": balanceState})
    }

    function openAddressScreen(balance, accountName, imagePath, balanceState, accountNumber) {
        stack.push("qrc:/WalletAddressScreen.qml", {"pushScreen": walletsTransitions(), "accountBalance": balance,
                       "accountName": accountName, "accountImage": imagePath, "balanceState": balanceState,
                       "accountNumber": accountNumber})
    }
}
