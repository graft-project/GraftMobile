import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../"
import "../pos"

GraftApplicationWindow {
    title: qsTr("POS")

    Drawer {
        id: drawer
        width: 0.75 * parent.width
        height: parent.height
        contentItem: Menu {
            pushScreen: screenTransitions()
        }
    }

    Connections {
        target: GraftClient

        onErrorReceived: {
            openMainScreen()
        }
    }

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: mainScreen
        focus: true
        Keys.onReleased: {
            if (!busy && (event.key === Qt.Key_Back || event.key === Qt.Key_Escape)) {
                pop()
                event.accepted = true
            }
        }
    }

    Loader {
        id: mainScreen
        source: "qrc:/pos/ProductScreen.qml"
        onLoaded: {
            item.pushScreen = screenTransitions()
        }
    }

    function screenTransitions() {
        var transitionsMap = {}
        transitionsMap["showMenu"] = showMenu
        transitionsMap["hideMenu"] = hideMenu
        transitionsMap["openAddScreen"] = openAddingScreen
        transitionsMap["initializingCheckout"] = openPaymentScreen
        transitionsMap["openWalletScreen"] = openInfoWalletScreen
        transitionsMap["backProductScreen"] = openMainScreen
        transitionsMap["goBack"] = turnBack
        return transitionsMap
    }

    function showMenu() {
        drawer.open()
    }

    function hideMenu() {
        drawer.close()
    }

    function openAddingScreen() {
        stack.push("qrc:/pos/AddingScreen.qml", {"pushScreen": screenTransitions(),
                       "currencyModel": [qsTr("USD"), qsTr("GRAFT")]})
    }

    function openPaymentScreen() {
        stack.push("qrc:/pos/PaymentScreen.qml", {"pushScreen": screenTransitions(),
                       "price": ProductModel.totalCost()})
    }

    function openInfoWalletScreen() {
        stack.push("qrc:/pos/InfoWallet.qml", {"pushScreen": screenTransitions()})
    }

    function openMainScreen() {
        stack.pop(mainScreen)
    }

    function turnBack() {
        stack.pop()
    }
}
