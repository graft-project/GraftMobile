import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "../"

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("WALLET")

    header: Header {
        headerText.text: "Wallet"
        leftIcon.source: "/imgs/menu_icon.png"
        rightIcon.source: "/imgs/cart_icon.png"
    }
}
