import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../"

ApplicationWindow {
    visible: true
    width: 320
    height: 480
    title: qsTr("WALLET")

    header: Header {
        headerText: qsTr("Wallet")
        menuIcon: "qrc:/imgs/menu_icon.png"
        cartIcon: "qrc:/imgs/cart_icon.png"
    }
}

