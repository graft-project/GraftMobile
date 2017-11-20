import QtQuick 2.9
import QtQuick.Layouts 1.3
import "../components"

BaseGraftToolBar {
    onSeclectedButtonChanged: {
        clearSelection()
        switch (buttonName) {
            case "Wallet": walletButton.buttonColor = clickedColor; break;
            case "Transaction": transactionButton.buttonColor = clickedColor; break;
            case "Transfer": transferButton.buttonColor = clickedColor; break;
            case "Settings": settingsButton.buttonColor = clickedColor; break;
        }
    }

    RowLayout {
        spacing: 18
        anchors.centerIn: parent

        ToolBarButton  {
            id: walletButton
            text: qsTr("Wallet")
            source: "qrc:/imgs/walletIos.png"
            buttonColor: clickedColor
            onClicked: pushScreen.openMainScreen()
        }

        ToolBarButton {
            id: transactionButton
            text: qsTr("Transaction")
            source: "qrc:/imgs/transactionIos.png"
            onClicked: pushScreen.openTransactionScreen()
        }

        ToolBarButton {
            id: transferButton
            text: qsTr("Transfer")
            source: "qrc:/imgs/transferIos.png"
            onClicked: pushScreen.openTransferScreen()
        }

        ToolBarButton {
            id: settingsButton
            text: qsTr("Settings")
            source: "qrc:/imgs/configIos.png"
            onClicked: pushScreen.openSettingsScreen()
        }

        ToolBarButton {
            id: aboutButton
            text: qsTr("About")
            source: "qrc:/imgs/infoIos.png"
            onClicked: Qt.openUrlExternally("https://www.graft.network/")
        }
    }

    function clearSelection() {
        walletButton.buttonColor = "transparent"
        transactionButton.buttonColor = "transparent"
        transferButton.buttonColor = "transparent"
        settingsButton.buttonColor = "transparent"
    }
}
