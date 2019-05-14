import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import com.graft.design 1.0
import com.device.platform 1.0
import org.navigation.attached.properties 1.0
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
                title: Detector.isPlatform(Platform.Android) ? qsTr("Item title") :
                                                               qsTr("Item title:")
                showLengthIndicator: true
                maximumLength: 50
            }

            RowLayout {
                spacing: 10

                LinearEditItem {
                    id: price
                    Layout.fillWidth: true
                    showLengthIndicator: false
                    Layout.topMargin: 2
                    Layout.alignment: Qt.AlignTop
                    Layout.preferredWidth: Detector.isPlatform(Platform.Android) ? 75 : 50
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    title: Detector.isPlatform(Platform.Android) ? qsTr("Price") : qsTr("Price:")
                    validator: RegExpValidator {
                        regExp: priceRegExp()
                    }
                }

                CurrencyComboBox {
                    id: currencyCBox
                    Layout.alignment: Qt.AlignTop
                    Layout.fillWidth: true
                    Layout.minimumWidth: 62
                    Layout.preferredWidth: Detector.isPlatform(Platform.Android) ? 30 : 50
                    dropdownTitle: Detector.isPlatform(Platform.Android) ? qsTr("Currency") :
                                                                           qsTr("Currency:")
                }
            }
        }

        WideActionButton {
            id: confirmButton
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignBottom
            text: qsTr("Checkout")
            KeyNavigation.tab: root.Navigation.implicitFirstComponent
            onClicked: checkout()
        }
    }

    function checkout() {
        if (!openScreenDialog(title.text, price.text)) {
            disableScreen()
            ProductModel.setQuickDealMode(true)
            ProductModel.add("", title.text, price.text,
                             currencyCBox.currentText, "")
            ProductModel.changeSelection(ProductModel.totalProductsCount() - 1)
            GraftClient.sale()
        }
    }
}
