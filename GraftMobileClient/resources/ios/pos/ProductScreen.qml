import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Dialogs 1.2
import org.graft 1.0
import com.graft.design 1.0
import com.device.platform 1.0
import "../components"
import "../"

BaseScreen {
    id: mainScreen
    title: qsTr("Store")
    screenHeader {
        cartEnable: true
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
            addButton.enabled = GraftClient.networkType() === GraftClientTools.PublicExperimentalTestnet
            quickDealButton.enabled = GraftClient.networkType() === GraftClientTools.PublicExperimentalTestnet
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#ffffff"

        ColumnLayout {
            spacing: 0
            anchors.fill: parent

            ListView {
                id: productList
                spacing: 0
                clip: true
                model: ProductModel
                delegate: productDelegate
                Layout.fillWidth: true
                Layout.fillHeight: true

                Component {
                    id: productDelegate
                    ProductSwipeDelegate {
                        width: productList.width
                        height: 60
                        selectState: selected
                        bottomLineVisible: index === (productList.count - 1)
                        visibleCheckBox: false
                        productImage: imagePath
                        productPrice: cost
                        productPriceTextColor: ColorFactory.color(DesignFactory.ItemText)
                        productText {
                            text: name
                            font.bold: true
                            color: ColorFactory.color(DesignFactory.MainText)
                        }

                        MessageDialog {
                            id: mobileMessageDialog
                            title: qsTr("Delete item")
                            icon: StandardIcon.Warning
                            text: qsTr("Are you sure that you want to remove this item?")
                            standardButtons: StandardButton.Yes | StandardButton.No
                            onYes: {
                                ProductModel.removeProduct(index)
                                GraftClient.saveProducts()
                            }
                        }

                        ChooserDialog {
                            id: desktopMessageDialog
                            topMargin: (mainScreen.height - desktopMessageDialog.height) / 2
                            leftMargin: (mainScreen.width - desktopMessageDialog.width) / 2
                            dialogMode: true
                            title: qsTr("Delete item")
                            dialogMessage: qsTr("Are you sure that you want to remove this item?")
                            denyButton {
                                text: qsTr("No")
                                onClicked: desktopMessageDialog.close()
                            }
                            confirmButton {
                                text: qsTr("Yes")
                                onClicked: {
                                    ProductModel.removeProduct(index)
                                    GraftClient.saveProducts()
                                }
                            }
                        }

                        onRemoveItemClicked: Detector.isDesktop() ? desktopMessageDialog.open() : mobileMessageDialog.open()
                        onEditItemClicked: pushScreen.openEditingItemScreen(index)
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
                enabled: GraftClient.networkType() === GraftClientTools.PublicExperimentalTestnet
                onClicked: {
                    if (ProductModel.totalCost() > 0) {
                        GraftClient.sale()
                    } else {
                        screenDialog.text = qsTr("Please, select one or more products to continue.")
                        screenDialog.open()
                    }
                }
            }

            WideActionButton {
                id: quickDealButton
                text: qsTr("Quick Deal")
                Material.accent: ColorFactory.color(DesignFactory.CircleBackground)
                Layout.alignment: Qt.AlignBottom
                Layout.leftMargin: 15
                Layout.rightMargin: 15
                Layout.bottomMargin: 15
                enabled: GraftClient.networkType() === GraftClientTools.PublicExperimentalTestnet
                onClicked: pushScreen.openQuickDealScreen()
            }
        }
    }
}
