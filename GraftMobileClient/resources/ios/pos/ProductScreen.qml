import QtQuick 2.9
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
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
        isNavigationButtonVisible: false
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
                Layout.fillWidth: true
                Layout.fillHeight: true
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
                        onRemoveItemClicked: {
                            var dialog = Detector.isDesktop() ? desktopMessageDialog :
                                                                mobileMessageDialog
                            dialog.removeItemIndex = index
                            dialog.open()
                        }
                        onEditItemClicked: pushScreen.openEditingItemScreen(index)
                    }
                }
            }

            AddNewButton {
                id: addNewProduct
                buttonTitle: qsTr("Add new product")
                Layout.preferredHeight: 60
                Layout.fillWidth: true
                onClicked: {
                    disableScreen()
                    pushScreen.openEditingItemScreen(-1)
                }
            }

            WideActionButton {
                id: addButton
                Layout.fillWidth: true
                Layout.topMargin: 15
                Layout.leftMargin: 15
                Layout.rightMargin: 15
                Layout.alignment: Qt.AlignBottom | Qt.AlignCenter
                text: qsTr("Checkout")
                enabled: GraftClient.networkType() === GraftClientTools.PublicExperimentalTestnet
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
                text: qsTr("Quick Deal")
                Material.accent: ColorFactory.color(DesignFactory.CircleBackground)
                enabled: GraftClient.networkType() === GraftClientTools.PublicExperimentalTestnet
                onClicked: {
                    disableScreen()
                    pushScreen.openQuickDealScreen()
                }
            }
        }
    }

    MessageDialog {
        id: mobileMessageDialog

        property int removeItemIndex: -1

        title: qsTr("Delete item")
        icon: StandardIcon.Warning
        text: qsTr("Are you sure that you want to remove this item?")
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: {
            deleteItem(removeItemIndex)
            removeItemIndex = -1
            mobileMessageDialog.close()
        }
    }

    ChooserDialog {
        id: desktopMessageDialog

        property int removeItemIndex: -1

        topMargin: (mainScreen.height - desktopMessageDialog.height) / 2
        leftMargin: (mainScreen.width - desktopMessageDialog.width) / 2
        dialogMode: true
        title: qsTr("Delete item")
        dialogMessage: qsTr("Are you sure that you want to remove this item?")
        confirmButtonText: qsTr("Yes")
        denyButtonText: qsTr("No")
        onConfirmed: {
            deleteItem(removeItemIndex)
            removeItemIndex = -1
            desktopMessageDialog.close()
        }
        onDenied: desktopMessageDialog.close()
    }

    function deleteItem(index) {
        ProductModel.removeProduct(index)
        GraftClient.saveProducts()
    }
}
