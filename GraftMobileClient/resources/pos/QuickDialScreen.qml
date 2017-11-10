import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.graft.design 1.0
import "../components"

BaseScreen {
    id: root

    property alias currencyModel: currencyCBox.currencyModel

    screenHeader {
        navigationButtonState: Qt.platform.os !== "android"
        actionButtonState: true
    }
    action: pushScreen.initializingCheckout

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
                spacing: 20

                LinearEditItem {
                    id: price
                    Layout.fillWidth: true
                    showLengthIndicator: false
                    inputMethodHints: Qt.ImhDigitsOnly
                    title: Qt.platform.os === "android" ? qsTr("Price") : qsTr("Price:")
                }

                CurrencyComboBox {
                    id: currencyCBox
                    Layout.preferredWidth: Qt.platform.os === "android" ? root.width * 0.25 : root.width * 0.5
                    Layout.alignment: Qt.AlignTop
                    dropdownTitle: Qt.platform.os === "android" ? qsTr("Currency") : qsTr("Currency:")
                }
            }
        }

        WideActionButton {
            id: confirmButton
            Layout.alignment: Qt.AlignBottom
            text: Qt.platform.os === "android" ? qsTr("CONFIRM") : qsTr("Checkout")
            onClicked: pushScreen.initializingCheckout()
        }
    }
}
