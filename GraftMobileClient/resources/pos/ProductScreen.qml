import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.2
import "../components"
import "../"

BaseScreen {
    id: mainScreen
    title: qsTr("Point of Sale")
    cartEnable: true

    ColumnLayout {
        anchors.fill: parent

        ListView {
            id: productList
            clip: true
            model: ProductModel
            delegate: productDelegate
            Layout.fillWidth: true
            Layout.fillHeight: true

            Component {
                id: productDelegate
                ProductDelegate {
                    width: productList.width
                    productImage: imagePath
                    productName: name
                    productPrice: cost
                    selectState: selected
                }
            }
        }

        WideRoundButton {
            id: addButton
            text: qsTr("Checkout")
            onClicked: mainScreen.pushScreen.initialCheckout()
        }

        RoundButton {
            padding: 20
            highlighted: true
            Material.elevation: 0
            Material.accent: "#d7d7d7"
            Layout.preferredHeight: addButton.height*1.4
            Layout.preferredWidth: height
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: 10
            Layout.bottomMargin: 10
            contentItem: Image {
                source: "qrc:/imgs/plus_icon.png"
            }
            onClicked: mainScreen.pushScreen.openAddScreen()
        }
    }
}
