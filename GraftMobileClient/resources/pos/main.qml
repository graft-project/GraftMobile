import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../"

ApplicationWindow {
    visible: true
    width: 320
    height: 480
    title: qsTr("POS")

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
        pushScreen: productPush()
    }

    function productPush() {
        var transitionsMap = {}
        transitionsMap["openAddScreen"] = openAddingScreen
        transitionsMap["initialCheckout"] = openPaymentScreen
        return transitionsMap
    }

    function stackPop() {
        stack.pop()
    }

    function openAddingScreen() {
        stack.push("qrc:/pos/AddingScreen.qml", {"pushScreen": stackPop,
                    "currencyModel": [qsTr("USD"), qsTr("GRAFT")]})
    }

    function openPaymentScreen() {
        stack.push("qrc:/pos/PaymentScreen.qml", {"pushScreen": stackPop,
                       "price": ProductModel.totalCost()})
    }
}
