import QtQuick 2.0
import org.graft 1.0
import "../"

BaseStackViewer {
    id: stack
    initialItem: balanceScreen

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

    function openMainScreen() {
        stack.pop(balanceScreen)
    }

    function openPaymentScreen(state) {
        stack.push("qrc:/PaymentScreen.qml", {"pushScreen": openMainScreen, "title": qsTr("Pay"),
                   "isSpacing": true, "completeText": qsTr("Paid complete!"), "screenState": state})
    }

    function openAddAccountScreen() {
        stack.push("qrc:/AddAccountScreen.qml", {"pushScreen": walletsTransitions(),
                   "coinModel": CoinModel})
    }

    function openMainAddressScreen() {
        stack.push("qrc:/WalletAddressScreen.qml", {"pushScreen": walletsTransitions()})
    }

    function openAddressScreen(balance, accountName, imagePath, balanceState, accountNumber) {
        stack.push("qrc:/WalletAddressScreen.qml", {"pushScreen": walletsTransitions(),
                   "accountBalance": balance, "accountName": accountName, "accountImage": imagePath,
                   "balanceState": balanceState, "accountNumber": accountNumber})
    }
}
