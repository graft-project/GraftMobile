import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
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

    Rectangle {
        anchors.fill: parent
        color: "#e9e9e9"

        ColumnLayout {
            spacing: 0
            anchors.fill: parent

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#ffffff"

                ListView {
                    id: productList
                    spacing: 0
                    clip: true
                    model: ProductModel
                    delegate: productDelegate
                    anchors.fill: parent

                    Component {
                        id: productDelegate
                        ProductSwipeDelegate {
                            width: productList.width
                            height: 60
                            selectState: selected
                            bottomLineVisible: false
                            topLineVisible: false
                            productImage: imagePath
                            productPrice: cost
                            productPriceTextColor: ColorFactory.color(DesignFactory.ItemText)
                            productText {
                                text: name
                                color: ColorFactory.color(DesignFactory.MainText)
                            }

                            onRemoveItemClicked: {
                                ProductModel.removeProduct(index)
                                GraftClient.save()
                            }

                            onEditItemClicked: {
                                pushScreen.openEditingItemScreen(index)
                            }
                        }
                    }
                }
            }

            WideActionButton {
                id: addButton
                text: qsTr("Checkout")
                Layout.bottomMargin: 90
                Layout.topMargin: 10
                onClicked: GraftClient.sale()
            }

            RoundButton {
                padding: 25
                highlighted: true
                Material.accent: ColorFactory.color(DesignFactory.CircleBackground)
                Layout.preferredHeight: addButton.height * 1.4
                Layout.preferredWidth: height
                Layout.alignment: Qt.AlignRight
                Layout.rightMargin: 10
                Layout.bottomMargin: 10
                contentItem: Image {
                    source:  "qrc:/imgs/plus_icon.png"
                }
                onClicked: pushScreen.openEditingItemScreen(-1)
            }
        }
    }
}
