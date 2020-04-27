import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Dialogs 1.2
import org.graft 1.0
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

    Connections {
        target: GraftClient
        onSaleReceived: {
            if (result) {
                pushScreen.initializingCheckout()
            } else {
//                TODO: Add error handling
            }
        }
        onNetworkTypeChanged: {
            addButton.enabled = true;
            //quickDealButton.enabled = GraftClient.networkType() === GraftClientTools.PublicExperimentalTestnet || GraftClientTools.PublicTestnet
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
                    anchors.fill: parent
                    delegate: productDelegate
                    model: ProductModel
                    clip: true
                    spacing: 0
                    ScrollBar.vertical: ScrollBar {
                        width: 5
                    }

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
                                text: qsTr("Are you sure that you want to remove this item?")
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
                Layout.fillWidth: true
                Layout.topMargin: 15
                Layout.leftMargin: 15
                Layout.rightMargin: 15
                Layout.alignment: Qt.AlignBottom | Qt.AlignCenter
                text: qsTr("Checkout")
                enabled: true
                onClicked: {
                    if (ProductModel.totalCost() > 0) {
                        disableScreen()
                        GraftClient.sale()
                    } else {
                        screenDialog.text = qsTr("Please, select one or more products to continue.")
                        screenDialog.open()
                    }
                }
            }

            WideActionButton {
                id: quickDealButton
                Layout.fillWidth: true
                Layout.leftMargin: 15
                Layout.rightMargin: 15
                Layout.bottomMargin: 15
                Layout.alignment: Qt.AlignBottom | Qt.AlignCenter
                text: qsTr("QUICK DEAL")
                Material.accent: ColorFactory.color(DesignFactory.CircleBackground)
                enabled: true
                onClicked: {
                    disableScreen()
                    pushScreen.openQuickDealScreen()
                }
            }
        }
    }
}
