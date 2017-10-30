import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import "../"
import "../components"

BaseScreen {
    title: qsTr("Add new account")
    screenHeader {
        actionButtonState: true
        actionText: qsTr("Save")
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        LinearEditItem {
            Layout.fillWidth: true
            title: qsTr("Account name:")
            maximumLength: 50
        }

        RowLayout {
            spacing: 10

            Text {
                id: dropdownTitle
                Layout.fillWidth: true
                color: "#BBBBBB"
                font.pointSize: 12
                text: qsTr("Type: ")
            }

            ComboBox {
                Layout.fillWidth: true
                Material.background: "#00707070"
                Material.foreground: "#585858"
                leftPadding: -12
                Layout.topMargin: -12
                Layout.bottomMargin: -10
                model: ["", "Bitcoin", "Zcash"]
            }
        }

        Rectangle {
            height: 1
            color: "#acacac"
            Layout.fillWidth: true
        }

        LinearEditItem {
            Layout.fillWidth: true
            title: qsTr("Wallet number:")
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            showLengthIndicator: false
            validator: RegExpValidator {
                regExp: /\d+\d{25}/
            }
        }

//        Rectangle {
//            Layout.fillHeight: true
//            Layout.fillWidth: true
//        }

        WideActionButton {
            text: qsTr("Scan QR Code")
            onClicked: pushScreen.openQRCodeScanner()
        }

        WideActionButton {
            text: qsTr("Add")
            Layout.bottomMargin: 15
            onClicked: pushScreen.openQRCodeScanner()
        }
    }
}
