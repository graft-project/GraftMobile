import QtQuick 2.9
import QtQuick.Layouts 1.3
import "../wallet"
import "../"
import "../components"

BaseBalanceScreen {
    splitterVisible: false


    addContent: ColumnLayout {
        width: parent.width
        height: parent.height
        spacing: 0

        ListView {
            id: accountListView

            Layout.fillWidth: true
            Layout.fillHeight: true

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

        ColumnLayout {
            Layout.fillWidth: true

            AddCardButton {
                Layout.alignment: Qt.AlignLeft
                imageSource: "qrc:/imgs/add_ios.png"
                textItem.color: "#067DFF"
                textItem.text: "Add Card"
                onClicked: pushScreen.addCardScreen()
            }

            WideActionButton {
                text: qsTr("PAY")
                onPressed: {
                    pushScreen.openQRCodeScanner()
                }
            }
        }
    }
}
