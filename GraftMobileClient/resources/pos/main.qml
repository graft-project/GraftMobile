import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../"

ApplicationWindow {
    visible: true
    width: 320
    height: 480
    title: qsTr("POS")

    Drawer {
        id: drawer
        width: 0.75 * parent.width
        height: parent.height
        contentItem: PosMenu {
            balanceInGraft: "1.15"
            pushScreen: transitionsInScreens()
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

    ProductScreen {
        id: mainScreen
        pushScreen: transitionsInScreens()
    }

    function transitionsInScreens() {
        var transitionsMap = {}
        transitionsMap["showMenu"] = showingMenu
        transitionsMap["hideMenu"] = hidingMenu
        transitionsMap["openAddScreen"] = openAddingScreen
        transitionsMap["initializingCheckout"] = openPaymentScreen
        transitionsMap["openWalletScreen"] = openInfoWalletScreen
        transitionsMap["backProductScreen"] = openMainScreen
        transitionsMap["goBack"] = turningBack
        return transitionsMap
    }

    function showingMenu() {
        drawer.open()
    }

    function hidingMenu() {
        drawer.close()
    }

    function openAddingScreen() {
        stack.push("qrc:/pos/AddingScreen.qml", {"pushScreen": transitionsInScreens(),
                                                 "currencyModel": [qsTr("USD"), qsTr("GRAFT")]})
    }

    function openPaymentScreen() {
        stack.push("qrc:/pos/PaymentScreen.qml", {"pushScreen": transitionsInScreens(),
                                                  "price": ProductModel.totalCost()})
    }

    function openInfoWalletScreen() {
        stack.push("qrc:/pos/InfoWallet.qml", {"pushScreen": transitionsInScreens()})
    }

    function openMainScreen() {
        stack.pop(mainScreen)
    }

    function turningBack() {
        stack.pop()
    }
}
