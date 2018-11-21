import QtQuick 2.0
import org.graft 1.0
import "../"

BaseStackViewer {
    id: stack
    initialItem: balanceScreen
    clearStackViewer: openBalanceScreen

    BalanceScreen {
        id: balanceScreen
        amountUnlockGraft: GraftClient.balance(GraftClientTools.UnlockedBalance)
        amountLockGraft: GraftClient.balance(GraftClientTools.LockedBalance)
        pushScreen: walletsTransitions()
    }

    function walletsTransitions() {
        var transitionsMap = pushScreen
        transitionsMap["openQRCodeScanner"] = openQRScanningScreen
        transitionsMap["addCardScreen"] = openAddCardScreen
        transitionsMap["openPaymentConfirmationScreen"] = openPaymentConfirmationScreen
        transitionsMap["openPaymentScreen"] = openPaymentScreen
        transitionsMap["openAddAccountScreen"] = openAddAccountScreen
        transitionsMap["openMainAddressScreen"] = openMainAddressScreen
        transitionsMap["openAddressScreen"] = openAddressScreen
        transitionsMap["openSendCoinScreen"] = openSendCoinScreen
        transitionsMap["openBalanceScreen"] = openBalanceScreen
        transitionsMap["openSendConfirmationScreen"] = openSendConfirmationScreen
        transitionsMap["goBack"] = goBack
        return transitionsMap
    }

    function openQRScanningScreen() {
        stack.push("qrc:/wallet/QRScanningScreen.qml", {"pushScreen": walletsTransitions()})
    }

    function openAddCardScreen() {
        stack.push("qrc:/wallet/AddCardScreen.qml", {"pushScreen": walletsTransitions()})
    }

    function openPaymentConfirmationScreen() {
        stack.push("qrc:/wallet/PaymentConfirmationScreen.qml", {
                   "pushScreen": walletsTransitions(),
                   "productModel": PaymentProductModel})
    }

    function openSendCoinScreen() {
        stack.push("qrc:/SendCoinScreen.qml", {"pushScreen": walletsTransitions()})
    }

    function openBalanceScreen() {
        stack.pop(balanceScreen)
    }

    function openPaymentScreen(state, isSendFlow) {
        stack.push("qrc:/PaymentScreen.qml", {"pushScreen": walletsTransitions(),
                   "title": isSendFlow ? qsTr("Send") : qsTr("Pay"), "isSpacing": true,
                   "completeText": isSendFlow ? qsTr("Send complete!") : qsTr("Payment completed!"),
                   "screenState": state, "pushMainScreen": openBalanceScreen})
    }

    function openAddAccountScreen() {
        stack.push("qrc:/AddAccountScreen.qml", {"pushScreen": walletsTransitions(),
                   "coinModel": CoinModel})
    }

    function openMainAddressScreen() {
        stack.push("qrc:/WalletAddressScreen.qml", {"pushScreen": walletsTransitions()})
    }

    function openAddressScreen(balance, accountName, imagePath, accountNumber, type) {
        stack.push("qrc:/WalletAddressScreen.qml", {"pushScreen": walletsTransitions(),
                   "accountBalance": balance, "accountName": accountName, "accountImage": imagePath,
                   "balanceState": "coinsAddress", "accountNumber": accountNumber, "accountType": type})
    }

    function openSendConfirmationScreen(receiversAddress, coinsAmount, fee) {
        stack.push("qrc:/SendConfirmationScreen.qml", {"pushScreen": walletsTransitions(),
                   "address": receiversAddress, "amount": coinsAmount, "fee": fee})
    }
}
