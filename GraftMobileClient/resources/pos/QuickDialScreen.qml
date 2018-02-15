import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import com.graft.design 1.0
import com.device.platform 1.0
import "../components"

BaseScreen {
    id: root

    property alias currencyModel: currencyCBox.currencyModel

    title: qsTr("Quick Deal")
    screenHeader.actionButtonState: true
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
                title: Detector.isPlatform(Platform.Android) ? qsTr("Item title") : qsTr("Item title:")
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
                    Layout.alignment: Qt.AlignTop
                    Layout.preferredWidth: Detector.isPlatform(Platform.Android) ? 75 : 50
                    inputMethodHints: Qt.ImhDigitsOnly
                    title: Detector.isPlatform(Platform.Android) ? qsTr("Price") : qsTr("Price:")
                }

                CurrencyComboBox {
                    id: currencyCBox
                    Layout.alignment: Qt.AlignTop
                    Layout.preferredWidth: Detector.isPlatform(Platform.Android) ? 30 : Detector.detectDevice() === Platform.IPhoneSE ? 165 : 50
                    dropdownTitle: Detector.isPlatform(Platform.Android) ? qsTr("Currency") : qsTr("Currency:")
                }
            }
        }

        WideActionButton {
            id: confirmButton
            Layout.alignment: Qt.AlignBottom
            text: qsTr("Checkout")
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
        } else {
            screenDialog.text = qsTr("The price cannot be zero. Please, enter the price.")
            screenDialog.open()
        }
    }
}
