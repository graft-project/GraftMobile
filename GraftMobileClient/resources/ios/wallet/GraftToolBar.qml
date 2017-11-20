import QtQuick 2.9
import QtQuick.Layouts 1.3
import com.graft.design 1.0
import "../components"

Rectangle {
    property var pushScreen

    signal seclectedButtonChanged(string buttonName)

    height: 49
    color: ColorFactory.color(DesignFactory.IosNavigationBar)

    Component.onCompleted: seclectedButtonChanged("Wallet")

    onSeclectedButtonChanged: {
        crearSelection()
        switch (buttonName) {
        case "Wallet": walletButton.buttonColor = "#25FFFFFF"; break;
        case "Transaction": transactionButton.buttonColor = "#25FFFFFF"; break;
        case "Transfer": transferButton.buttonColor = "#25FFFFFF"; break;
        case "Settings": settingsButton.buttonColor = "#25FFFFFF"; break;
        }
    }

    RowLayout {
        spacing: 18
        anchors.centerIn: parent

        ToolBarButton  {
            id: walletButton
            text: qsTr("Wallet")
            source: "qrc:/imgs/walletIos.png"
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

    function crearSelection(){
        walletButton.buttonColor = "transparent"
        transactionButton.buttonColor = "transparent"
        transferButton.buttonColor = "transparent"
        settingsButton.buttonColor = "transparent"
    }
}
