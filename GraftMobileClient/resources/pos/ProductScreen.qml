import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.2

Item {
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
        }
    }

    RoundButton {
        id: addButton
        radius: 14
        topPadding: 15
        bottomPadding: 15
        highlighted: true
        Material.elevation: 0
        Material.accent: "#757575"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 94
        anchors.right: parent.right
        anchors.rightMargin: 40
        anchors.left: parent.left
        anchors.leftMargin: 40
        text: qsTr("Checkout")
        font {
            family: "Liberation Sans"
            pointSize: 14
            capitalization: Font.MixedCase
        }
    }

    RoundButton {
        padding: 21
        width: height
        highlighted: true
        Material.elevation: 0
        Material.accent: "#d7d7d7"
        anchors.top: addButton.bottom
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        contentItem: Image {
            source: "qrc:/imgs/plus_icon.png"
        }
    }

    ListModel {
        id: productModel

        ListElement {
            name: "Hairout 1"
            image: "qrc:/examples/bob-haircuts.png"
            cost: 25
        }

        ListElement {
            name: "Hairout 2"
            image: "qrc:/examples/images.png"
            cost: 20
        }
    }
}
