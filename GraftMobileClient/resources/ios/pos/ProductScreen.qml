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
                            id: messageDialog
                            title: qsTr("Delete item")
                            icon: StandardIcon.Warning
                            text: qsTr("Are you sure that you want to remove this particular item?")
                            standardButtons: StandardButton.Yes | StandardButton.No
                            onYes: {
                                ProductModel.removeProduct(index)
                                GraftClient.save()
                            }
                        }

                        onRemoveItemClicked: messageDialog.open()
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
                Layout.topMargin: 10
                Layout.leftMargin: 15
                Layout.rightMargin: 15
                Layout.bottomMargin: 15
                onClicked: GraftClient.sale()
            }

            WideActionButton {
                id: quickDealButton
                text: qsTr("Quick Deal")
                Material.accent: ColorFactory.color(DesignFactory.CircleBackground)
                Layout.alignment: Qt.AlignBottom
                Layout.topMargin: 10
                Layout.leftMargin: 15
                Layout.rightMargin: 15
                Layout.bottomMargin: 15
                onClicked: pushScreen.openQuickDealScreen()
            }
        }
    }
}
