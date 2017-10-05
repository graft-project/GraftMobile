import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import "../"
import "../components"

BaseScreen {
    id: root
    title: qsTr("Add Card")
    screenHeader {
        navigationButtonState: Qt.platform.os !== "android"
        actionButtonState: true
    }
    action: done

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: childrenRect.height
            Layout.topMargin: parent.width / 12
            Layout.bottomMargin: parent.width / 12

            Image {
                id: graftWalletLogo
                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                }
                width: parent.width / 2
                fillMode: Image.PreserveAspectFit
                source: "qrc:/imgs/card_icon.png"
            }
        }

        LinearEditItem {
            id: title
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            title: qsTr("Card Title")
            maximumLength: 50
        }

        LinearEditItem {
            id: number
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            title: qsTr("Card Number")
            inputMethodHints: Qt.ImhDigitsOnly
            validator: RegExpValidator {
                regExp: /(5\d{15}|4\d{15}|30\d{14})/
            }
            maximumLength: 16
        }

        RowLayout {
            Layout.leftMargin: 15
            Layout.rightMargin: 15
            spacing: parent.width / 2

            LinearEditItem {
                id: expired
                Layout.alignment: Qt.AlignTop
                title: qsTr("Expiration Date")
                inputMask: "00/00;0"
                inputMethodHints: Qt.ImhDate
                validator: RegExpValidator {
                    regExp: /\d{4}/
                }
                maximumLength: 6
                showLengthIndicator: false
            }

            LinearEditItem {
                id: cv2Code
                title: qsTr("CVC/CVV2")
                inputMethodHints: Qt.ImhDigitsOnly
                validator: RegExpValidator {
                    regExp: /\d{3}/
                }
                maximumLength: 3
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignBottom
            Layout.bottomMargin: 15
            spacing: 0

            WideActionButton {
                id: scanCardButton
                text: qsTr("SCAN CARD")
                onClicked: {
                    scanCardButton.text = qsTr("WILL BE SOON")
                }
            }

            WideActionButton {
                id: confirmButton
                text: qsTr("CONFIRM")
                onClicked: done()
            }
        }
    }

    function done() {
        CardModel.add(title.text, number.text, cv2Code.text, expired.text)
        pushScreen.goBack()
    }
}
