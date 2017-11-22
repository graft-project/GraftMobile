import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Dialogs 1.2
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

                            MessageDialog {
                                id: messageDialog
                                title: qsTr("Delete item")
                                icon: StandardIcon.Warning
                                text: qsTr("Are you sure that you want to remove this particular item?")
                                standardButtons: StandardButton.Yes | StandardButton.No
                                onYes: {
                                    ProductModel.removeProduct(index)
                                    GraftClient.saveProducts()
                                }
                            }

                            onRemoveItemClicked: messageDialog.open()
                            onEditItemClicked: pushScreen.openEditingItemScreen(index)
                        }
                    }
                }
            }

            AddNewButton {
                buttonTitle: qsTr("Add new product")
                Layout.preferredHeight: 60
                Layout.fillWidth: true
                onClicked: pushScreen.openEditingItemScreen(-1)
            }

            WideActionButton {
                id: addButton
                text: qsTr("Checkout")
                Layout.alignment: Qt.AlignBottom
                Layout.topMargin: 15
                Layout.leftMargin: 15
                Layout.rightMargin: 15
                onClicked: {
                    if (ProductModel.totalCost() > 0) {
                        GraftClient.sale()
                        pushScreen.initializingCheckout()
                    }
                }
            }

            WideActionButton {
                id: quickDealButton
                text: qsTr("QUICK DEAL")
                Material.accent: ColorFactory.color(DesignFactory.CircleBackground)
                Layout.alignment: Qt.AlignBottom
                Layout.leftMargin: 15
                Layout.rightMargin: 15
                Layout.bottomMargin: 15
                onClicked: pushScreen.openQuickDealScreen()
            }
        }
    }
}
