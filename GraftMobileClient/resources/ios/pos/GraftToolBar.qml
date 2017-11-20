import QtQuick 2.9
import QtQuick.Layouts 1.3
import "../components"

BaseGraftToolBar {
    onSeclectedButtonChanged: {
        clearSelection()
        switch (buttonName) {
            case "Store": storeButton.buttonColor = clickedColor; break;
            case "Wallet": walletButton.buttonColor = clickedColor; break;
            case "Settings": settingsButton.buttonColor = clickedColor; break;
        }
    }

    RowLayout {
        spacing: 40
        anchors.centerIn: parent

        ToolBarButton  {
            id: storeButton
            text: qsTr("Store")
            source: "qrc:/imgs/storeIos.png"
            buttonColor: clickedColor
            onClicked: pushScreen.openMainScreen()
        }

        ToolBarButton {
            id: walletButton
            text: qsTr("Wallet")
            source: "qrc:/imgs/walletIos.png"
            onClicked: pushScreen.openWalletScreen()
        }

        ToolBarButton {
            id: settingsButton
            text: qsTr("Settings")
            source: "qrc:/imgs/configIos.png"
            onClicked: pushScreen.openSettingsScreen()
        }

        ToolBarButton {
            text: qsTr("About")
            source: "qrc:/imgs/infoIos.png"
            onClicked: Qt.openUrlExternally("https://www.graft.network/")
        }
    }

    function clearSelection() {
        storeButton.buttonColor = "transparent"
        walletButton.buttonColor = "transparent"
        settingsButton.buttonColor = "transparent"
    }
}
