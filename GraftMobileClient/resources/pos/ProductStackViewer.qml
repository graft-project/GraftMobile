import QtQuick 2.0
import "../"

BaseStackViewer {
    id: stack
    initialItem: productScreen

    ProductScreen {
        id: productScreen
        pushScreen: posTransitions()
    }

    function posTransitions() {
        var transitionsMap = pushScreen
        transitionsMap["openEditingItemScreen"] = openEditingItemScreen
        transitionsMap["openQuickDealScreen"] = openQuickDealScreen
        transitionsMap["initializingCheckout"] = openCartScreen
        transitionsMap["openPaymentScreen"] = openPaymentScreen
        transitionsMap["clearChecked"] = clearChecked
        transitionsMap["goBack"] = goBack
        return transitionsMap
    }

    function openMainScreen() {
        stack.pop(productScreen)
    }

    function openEditingItemScreen(index) {
        stack.push("qrc:/pos/EditingItemScreen.qml", {"pushScreen": posTransitions(),
                   "currencyModel": CurrencyModel, "index": index})
    }

    function openQuickDealScreen() {
        stack.push("qrc:/pos/QuickDialScreen.qml", {"pushScreen": posTransitions(),
                   "textLabel": qsTr("Quick Dial"), "currencyModel": CurrencyModel})
    }

    function openCartScreen() {
        stack.push("qrc:/pos/CartScreen.qml", {"pushScreen": posTransitions(),
                   "price": ProductModel.totalCost()})
    }

    function clearChecked() {
        stack.pushScreen.privateClearChecked()
        stack.pop(productScreen)
    }

    function openPaymentScreen() {
        stack.push("qrc:/PaymentScreen.qml", {"pushScreen": clearChecked,
                   "title": qsTr("Cart"), "textLabel": qsTr("Checkout complete!"),
                   "isSpacing": false})
    }
}
