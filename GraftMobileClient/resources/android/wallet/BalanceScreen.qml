import QtQuick 2.9
import QtQuick.Layouts 1.3
import "../"
import "../components"

BaseBalanceScreen {
    splitterVisible: true

    ColumnLayout {
        spacing: 0
        anchors {
            fill: parent
            leftMargin: 15
            rightMargin: 15
        }

        ListView {
            id: accountListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.topMargin: 5
            model: CardModel
            clip: true
            spacing: 15
            delegate: AccountDelegate {
                width: accountListView.width
                height: 30
                nameItem.text: cardName
                cardIcon: "qrc:/imgs/MasterCard_Logo.png"
                number: cardHideNumber
            }
        }

        AddCardButton {
            Layout.alignment: Qt.AlignLeft
            textItem.text: qsTr("+  Add Card")
            imageVisible: false
            onClicked: pushScreen.addCardScreen()
        }

        WideActionButton {
            text: qsTr("PAY")
            Layout.bottomMargin: 15
            onClicked: pushScreen.openQRCodeScanner()
        }
    }
}
