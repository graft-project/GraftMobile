import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.graft.design 1.0
import org.graft.models 1.0
import "../components"
import "../"

BaseScreen {
    id: additionItem
    title: qsTr("Add item")
    action: additionItem.confirmProductParameters
    Component.onCompleted: init()

    screenHeader {
        navigationButtonState: Qt.platform.os === "ios"
        actionButtonState: true
    }

    property alias currencyModel: productItem.currencyModel
    property int index: -1

    function init() {
        if (Qt.platform.os === "ios") {
            navigationText: qsTr("Cancel")
            actionText: qsTr("Done")
        }
    }

    function confirmProductParameters() {
        var currencyCode = currencyModel.codeOf(productItem.currencyText)

        if(index >= 0) {
            ProductModel.setProductData(index, productItem.titleText, ProductModelEnum.TitleRole)
            ProductModel.setProductData(index, productItem.previewImage, ProductModelEnum.ImageRole)
            ProductModel.setProductData(index, productItem.price, ProductModelEnum.CostRole)
            ProductModel.setProductData(index, currencyCode, ProductModelEnum.CurrencyRole)
            ProductModel.setProductData(index, productItem.descriptionText, ProductModelEnum.DescriptionRole)
        } else {
            ProductModel.add(productItem.previewImage, productItem.titleText, productItem.price,
                             currencyCode, productItem.descriptionText)
        }
        additionItem.pushScreen.openProductScreen()
        GraftClient.save()
    }

    onIndexChanged: {
        title = qsTr("Edit item")
        multiTaskingButton.text = qsTr("Save")
        productItem.titleText = ProductModel.productData(index, ProductModelEnum.TitleRole)
        productItem.previewImage = ProductModel.productData(index, ProductModelEnum.ImageRole)
        productItem.price = ProductModel.productData(index, ProductModelEnum.CostRole)
        productItem.descriptionText = ProductModel.productData(index, ProductModelEnum.DescriptionRole)
        productItem.currencyIndex = currencyModel.indexOf(ProductModel.productData(index, ProductModelEnum.CurrencyRole))
    }

    ColumnLayout {
        anchors {
            fill: parent
            topMargin: 10
            bottomMargin: 20
        }

        ProductItemView {
            id: productItem
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: 15
            Layout.rightMargin: 15
        }

        WideActionButton {
            id: multiTaskingButton
            text: qsTr("Confirm")
            onClicked: {
                confirmProductParameters()
            }
        }
    }
}
