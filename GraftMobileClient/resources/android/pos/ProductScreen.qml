import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import "../components"
import "../"

BaseScreen {
    id: mainScreen
    title: qsTr("Store")
    screenHeader {
        cartEnable: true
        navigationButtonState: true
    }

    Connections {
        target: GraftClient
        onSaleReceived: {
            if (result === true) {
                pushScreen.initializingCheckout()
            }
        }
    }

    Connections {
        target: ProductModel
        onSelectedProductCountChanged: {
            mainScreen.screenHeader.selectedProductCount = count
        }
    }

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
            onClicked: GraftClient.sale()
        }

        RoundButton {
            padding: 20
            highlighted: true
            Material.elevation: 0
            Material.accent: ColorFactory.color(DesignFactory.CircleBackground)
            Layout.preferredHeight: addButton.height * 1.4
            Layout.preferredWidth: height
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: 10
            Layout.bottomMargin: 10
            contentItem: Image {
                source: "qrc:/imgs/plus_icon.png"
            }
            onClicked: pushScreen.openAddScreen()
        }
    }
}
