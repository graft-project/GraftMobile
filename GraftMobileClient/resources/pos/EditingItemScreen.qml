import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import "../components"
import "../"

BaseScreen {
    id: additionItem
    title: qsTr("Add item")
    screenHeader {
//        android
//        navigationButtonState: false
//        actionButton: true

//        ios
//        navigationButtonState: true
//        navigationText: qsTr("Cancel")
//        actionButtonState: true
//        actionText: qsTr("Done")
    }

    property alias currencyModel: productItem.currencyModel

    function confirmProductParameters() {
    ProductModel.add(productItem.previewImage, productItem.titleText, productItem.price,
                     productItem.currencyModel, productItem.descriptionText)
    }

    ColumnLayout {
        spacing: 0
        anchors {
            fill: parent
            topMargin: 10
            bottomMargin: 20
        }

        ProductItemView {
            id: productItem
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        WideActionButton {
            id: multiTaskingButton
            text: qsTr("Confirm")
            onClicked: {
                confirmProductParameters()
                additionItem.pushScreen.openProductScreen()
                GraftClient.save()
            }
        }
    }
}
