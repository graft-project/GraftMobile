import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import com.graft.design 1.0
import "../components"

BaseScreen {
    id: root

    property alias currencyModel: currencyCBox.currencyModel

    title: qsTr("Quick Deal")
    screenHeader {
        navigationButtonState: Qt.platform.os !== "android"
        actionButtonState: true
    }
    action: checkout

    ColumnLayout {
        anchors {
            fill: parent
            margins: 15
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true

            LinearEditItem {
                id: title
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                title: Qt.platform.os === "android" ? qsTr("Item title") : qsTr("Item title:")
                showLengthIndicator: true
                maximumLength: 50
            }

            RowLayout {
                Layout.alignment: Qt.AlignTop
                spacing: 10

                LinearEditItem {
                    id: price
                    Layout.fillWidth: true
                    showLengthIndicator: false
                    inputMethodHints: Qt.ImhDigitsOnly
                    title: Qt.platform.os === "android" ? qsTr("Price") : qsTr("Price:")
                }

                CurrencyComboBox {
                    id: currencyCBox
                    Layout.preferredWidth: Qt.platform.os === "android" ? 50 : 130
                    Layout.alignment: Qt.AlignTop
                    dropdownTitle: Qt.platform.os === "android" ? qsTr("Currency") : qsTr("Currency:")
                }
            }
        }

        WideActionButton {
            id: confirmButton
            Layout.alignment: Qt.AlignBottom
            text: Qt.platform.os === "android" ? qsTr("CHECKOUT") : qsTr("Checkout")
            onClicked: checkout()
        }
    }

    function checkout() {
        if (price.text !== "") {
            ProductModel.setQuickDealMode(true)
            ProductModel.add("", title.text, price.text,
                             currencyModel.codeOf(currencyCBox.currencyText), "")
            ProductModel.changeSelection(ProductModel.totalProductsCount() - 1)
            GraftClient.sale()
            pushScreen.initializingCheckout()
        } else {
            messageDialog.open()
        }
    }

    MessageDialog {
        id: messageDialog
        title: qsTr("Attention")
        text: qsTr("The price cannot be zero. Please, enter the price.")
        icon: StandardIcon.Warning
    }
}
