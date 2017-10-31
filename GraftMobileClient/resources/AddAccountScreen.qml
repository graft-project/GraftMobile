import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import "components"

BaseScreen {
    property alias coinModel: graftComboBox.currencyModel

    title: qsTr("Add new account")
    action: saveAccount

    function saveAccount() {
        CardModel.add(title.text, number.text, cv2Code.text, expired.text)
        pushScreen.goBack()
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
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            showLengthIndicator: false
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
            onClicked: saveAccount()
        }
    }
}
