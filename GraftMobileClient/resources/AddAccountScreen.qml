import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Material 2.2
import "components"

BaseScreen {
    property alias coinModel: graftComboBox.currencyModel

    title: qsTr("Add new account")
    action: addAccount

    function addAccount() {
        if(linearAccountTitle.text !== "" && linearWalletTitle.text !== "") {
            if(AccountModel.existWalletNumbers(linearWalletTitle.text)) {
                AccountModel.add(CoinModel.codeOf(graftComboBox.currentText), linearAccountTitle.text, graftComboBox.currentText, linearWalletTitle.text)
                pushScreen.goBack()
            } else {
                dataRepeatMessage.open()
            }
        } else {
            dataEmptyMessage.open()
        }
    }

    MessageDialog {
        id: dataRepeatMessage
        title: qsTr("Attention")
        icon: StandardIcon.Warning
        text: qsTr("You re entered the data in Wallet number field - it's wrong! Check the entered data.")
    }

    MessageDialog {
        id: dataEmptyMessage
        title: qsTr("Attention")
        icon: StandardIcon.Warning
        text: qsTr("Don't leave blank fields as it isn't correct! You must enter the account name, type and wallet number.")
    }

    Component.onCompleted: {
        if(Qt.platform.os === "ios") {
            screenHeader.actionButtonState = true
            screenHeader.navigationButtonState = true
            screenHeader.actionText = qsTr("Save")
            linearAccountTitle.title = qsTr("Account name:")
            graftComboBox.dropdownTitle = qsTr("Type:")
            linearWalletTitle.title = qsTr("Wallet number:")
        } else {
            screenHeader.actionButtonState = true
            linearAccountTitle.title = qsTr("Account name")
            graftComboBox.dropdownTitle = qsTr("Type")
            linearWalletTitle.title = qsTr("Wallet number")
        }
    }

    ColumnLayout {
        spacing: 0
        anchors {
            fill: parent
            leftMargin: 15
            rightMargin: 15
            topMargin: 15
        }

        LinearEditItem {
            id: linearAccountTitle
            Layout.fillWidth: true
            maximumLength: 50
        }

        CurrencyComboBox {
            id: graftComboBox
        }

        LinearEditItem {
            id: linearWalletTitle
            Layout.fillWidth: true
            Layout.topMargin: 10
            inputMethodHints: Qt.ImhDigitsOnly && Qt.ImhLowercaseOnly
            showLengthIndicator: false
            validator: RegExpValidator {
                regExp: /[\da-zA-Z]+/
            }
        }

        Rectangle {
            Layout.fillHeight: true
        }

        WideActionButton {
            text: qsTr("Scan QR Code")
            Layout.topMargin: 5
            Layout.leftMargin: 0
            Layout.rightMargin: 0
            onClicked: {}
        }

        WideActionButton {
            text: qsTr("Add")
            Layout.leftMargin: 0
            Layout.rightMargin: 0
            Layout.bottomMargin: 15
            onClicked: addAccount()
        }
    }
}
