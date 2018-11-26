import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import com.device.platform 1.0
import "../"
import "../components"

BaseScreen {
    id: root
    title: qsTr("Add Card")
    screenHeader.actionButtonState: true
    action: done

    ColumnLayout {
        spacing: 0
        anchors {
            fill: parent
            leftMargin: 15
            rightMargin: 15
        }

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
            title: Detector.isPlatform(Platform.Android) ? qsTr("Card Title") : qsTr("Card Title:")
            maximumLength: 50
        }

        LinearEditItem {
            id: number
            title: Detector.isPlatform(Platform.Android) ? qsTr("Card Number") : qsTr("Card Number:")
            inputMethodHints: Qt.ImhDigitsOnly
            validator: RegExpValidator {
                regExp: /(5\d{15}|4\d{15}|30\d{14})/
            }
            maximumLength: 16
        }

        RowLayout {
            spacing: Detector.isPlatform(Platform.Android) ? parent.width / 2 : 30

            LinearEditItem {
                id: expired
                Layout.alignment: Qt.AlignTop
                title: Detector.isPlatform(Platform.Android) ? qsTr("Expiration Date") :
                                                               qsTr("Expired:")
                inputMask: "99/99;_"
                inputMethodHints: Qt.ImhDigitsOnly
                validator: RegExpValidator {
                    regExp: /\d{4}/
                }
                showLengthIndicator: false
            }

            LinearEditItem {
                id: cv2Code
                title: Detector.isPlatform(Platform.Android) ? qsTr("CVC/CVV2") : qsTr("CVC/CVV2:")
                inputMethodHints: Qt.ImhDigitsOnly
                validator: RegExpValidator {
                    regExp: /\d{3}/
                }
                showLengthIndicator: Detector.isPlatform(Platform.IOS | Platform.Desktop)
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
                text: qsTr("Scan Card")
                onClicked: scanCardButton.text = qsTr("WILL BE SOON")
            }

            WideActionButton {
                id: confirmButton
                text: qsTr("Confirm")
                onClicked: done()
            }
        }
    }

    function done() {
        CardModel.add(title.text, number.text, cv2Code.text, expired.text)
        pushScreen.goBack()
    }
}
