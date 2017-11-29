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
        transitionsMap["goBack"] = goBack
        return transitionsMap
    }

    function openAddAccountScreen() {
        stack.push("qrc:/AddAccountScreen.qml", {"pushScreen": walletTransitions(),
                   "coinModel": CoinModel})
    }
}
