import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import com.graft.design 1.0
import org.graft.models 1.0
import "../components"
import "../"

BaseScreen {
    id: editingItem
    title: qsTr("Add item")
    action: editingItem.confirmProductParameters

    screenHeader {
        navigationButtonState: Qt.platform.os === "ios"
        actionButtonState: true
    }

    property alias currencyModel: productItem.currencyModel
    property int index: -1

    Component.onCompleted: {
        if (Qt.platform.os === "ios") {
            navigationText: qsTr("Cancel")
            actionText: qsTr("Done")
        }
    }

    function confirmProductParameters() {
        var currencyCode = currencyModel.codeOf(productItem.currencyText)
        if (productItem.titleText !== "" && productItem.price !== "") {
            if (index >= 0) {
                ProductModel.setProductData(index, productItem.titleText, ProductModelEnum.TitleRole)
                ProductModel.setProductData(index, productItem.productImage, ProductModelEnum.ImageRole)
                ProductModel.setProductData(index, productItem.price, ProductModelEnum.CostRole)
                ProductModel.setProductData(index, currencyCode, ProductModelEnum.CurrencyRole)
                ProductModel.setProductData(index, productItem.descriptionText, ProductModelEnum.DescriptionRole)
            } else {
                ProductModel.add(productItem.productImage, productItem.titleText, productItem.price,
                                 currencyCode, productItem.descriptionText)
            }
            editingItem.pushScreen.openProductScreen()
            GraftClient.saveProduct()
        } else {
            messageDialog.open()
        }
    }

    onIndexChanged: {
        title = qsTr("Edit item")
        multiTaskingButton.text = qsTr("Save")
        productItem.titleText = ProductModel.productData(index, ProductModelEnum.TitleRole)
        productItem.productImage = ProductModel.productData(index, ProductModelEnum.ImageRole)
        productItem.price = ProductModel.productData(index, ProductModelEnum.CostRole)
        productItem.descriptionText = ProductModel.productData(index, ProductModelEnum.DescriptionRole)
        productItem.currencyIndex = currencyModel.indexOf(ProductModel.productData(index, ProductModelEnum.CurrencyRole))
    }

    MessageDialog {
        id: messageDialog
        title: qsTr("Attention")
        icon: StandardIcon.Warning
        text: qsTr("Don't leave blank fields as it isn't correct! You must enter the item title and price.")
    }

    ColumnLayout {
        anchors {
            fill: parent
            topMargin: 10
            leftMargin: 15
            rightMargin: 15
            bottomMargin: 15
        }

        ProductItemView {
            id: productItem
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        WideActionButton {
            id: multiTaskingButton
            text: qsTr("Confirm")
            onClicked: confirmProductParameters()
        }
    }
}
