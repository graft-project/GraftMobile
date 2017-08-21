import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.2
import "../components"
import "../"

BaseScreen {
    id: mainScreen
    title: qsTr("Pos")
    cartEnable: true

    ListView {
        id: productList
        anchors.fill: parent
        model: productModel
        delegate: productDelegate
    }

    Component {
        id: productDelegate
        ProductDelegate {
            width: productList.width
            productImage: imagePath
            productName: name
            productPrice: cost
            color: selected ? "transparent" : "#f2f2f2"
        }
    }

    WideRoundButton {
        id: addButton
        text: qsTr("Checkout")
        anchors {
            bottom: parent.bottom
            bottomMargin: 94
            right: parent.right
            rightMargin: 40
            left: parent.left
            leftMargin: 40
        }
        onClicked: mainScreen.pushScreen.initialCheckout()
    }

    RoundButton {
        padding: 21
        width: height
        highlighted: true
        Material.elevation: 0
        Material.accent: "#d7d7d7"
        anchors {
            top: addButton.bottom
            topMargin: 20
            right: parent.right
            rightMargin: 5
            bottom: parent.bottom
            bottomMargin: 5
        }
        contentItem: Image {
            source: "qrc:/imgs/plus_icon.png"
        }
        onClicked: mainScreen.pushScreen.openAddScreen()
    }
}
