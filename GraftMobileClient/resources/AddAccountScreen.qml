import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import "components"

BaseScreen {
    id: accountScreen
    property alias coinModel: coinsComboBox.currencyModel

    title: qsTr("Add new account")
    screenHeader.actionButtonState: true
    action: addAccount

    function addAccount() {
        if (accountName.text !== "" && walletNumberText.text !== "") {
            if (AccountModel.add(CoinModel.imageOf(coinsComboBox.currentText), accountName.text,
                                 CoinModel.codeOf(coinsComboBox.currentText), walletNumberText.text)) {
                GraftClient.saveAccounts()
                pushScreen.goBack()
            } else {
                attentionDialog.text = qsTr("The wallet number already exists! Please, "+
                                            "enter another wallet number.")
                attentionDialog.open()
            }
        } else {
            attentionDialog.text = qsTr("Don't leave blank fields as it isn't correct! "+
                                        "You must enter the account name, type and wallet number.")
            attentionDialog.open()
        }
    }

    Component.onCompleted: {
        if (Qt.platform.os === "ios") {
            screenHeader.navigationButtonState = true
            screenHeader.actionText = qsTr("Save")
            accountName.title = qsTr("Account name:")
            coinsComboBox.dropdownTitle = qsTr("Type:")
            walletNumberText.title = qsTr("Wallet number:")
        } else {
            accountName.title = qsTr("Account name")
            coinsComboBox.dropdownTitle = qsTr("Type")
            walletNumberText.title = qsTr("Wallet number")
        }
    }

    MessageDialog {
        id: attentionDialog
        title: qsTr("Attention")
        icon: StandardIcon.Warning
    }

    StackLayout {
        id: stackLayout

        anchors {
            fill: parent
            bottomMargin: 15
        }

        ColumnLayout {
            spacing: 0
            anchors {
                fill: parent
                margins: 15
            }

            LinearEditItem {
                id: accountName
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                maximumLength: 50
            }

            CurrencyComboBox {
                id: coinsComboBox
                Layout.alignment: Qt.AlignTop
            }

            LinearEditItem {
                id: walletNumberText
                Layout.fillWidth: true
                Layout.topMargin: 10
                Layout.alignment: Qt.AlignTop
                showLengthIndicator: false
                validator: RegExpValidator {
                    regExp: /[\da-zA-Z]+/
                }
            }

            Item {
                Layout.fillHeight: true
            }

            WideActionButton {
                text: qsTr("Scan QR Code")
                Layout.alignment: Qt.AlignBottom
                onClicked: stackLayout.currentIndex = 1
            }

            WideActionButton {
                text: qsTr("Add")
                Layout.alignment: Qt.AlignBottom
                onClicked: addAccount()
            }
        }

        QRScanningView {
            anchors.fill: parent
            onQrCodeDetected: {
                walletNumberText.text = message
                stackLayout.currentIndex = 0
            }
        }
    }
}
