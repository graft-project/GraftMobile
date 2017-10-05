import QtQuick 2.9
import QtQuick.Layouts 1.3
import "../"
import "../components"

BaseBalanceScreen {
    splitterVisible: true

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        ListView {
            id: accountListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: 8
            Layout.rightMargin: 8
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
            Layout.leftMargin: 20
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
