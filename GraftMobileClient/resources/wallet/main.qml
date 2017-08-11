import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../"

ApplicationWindow {
    id: root
    visible: true
    width: 320
    height: 480
    title: qsTr("WALLET")

    header: Header {
        headerText: qsTr("Wallet")
        menuIcon: "qrc:/imgs/menu_icon.png"
        cartIcon: "qrc:/imgs/cart_icon.png"
    }

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: screen1
    }

    BalanceView {
        id: screen1
        amountGraft: 2
        amountMoney: 145
        onPayButtonClicked: {
            var component = Qt.createComponent("qrc:/QRScanningScreen.qml");
            var sprite = component.createObject(root);

            stack.push(sprite)
        }
    }
}

