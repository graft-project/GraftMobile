import QtQuick 2.9
import QtQuick.Layouts 1.3
import "../"
import "../components"

BaseBalanceScreen {
    splitterVisible: false
    screenHeader {
        navigationButtonState: false
    }

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
            imageSource: "qrc:/imgs/add_ios.png"
            textItem {
                color: "#067DFF"
                text: "Add Card"
            }
            imageVisible: true
            onClicked: pushScreen.addCardScreen()
        }

        WideActionButton {
            text: qsTr("PAY")
            Layout.bottomMargin: 15
            onPressed: pushScreen.openQRCodeScanner()
        }
    }
}
