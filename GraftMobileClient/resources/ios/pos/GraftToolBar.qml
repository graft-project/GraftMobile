import QtQuick 2.9
import QtQuick.Layouts 1.3
import com.graft.design 1.0
import "../components"

Rectangle {
    property var pushScreen

    signal seclectedButtonChanged(string buttonName)

    height: 49
    color: ColorFactory.color(DesignFactory.IosNavigationBar)

    Component.onCompleted: seclectedButtonChanged("Store")

    onSeclectedButtonChanged: {
        crearSelection()
        switch (buttonName) {
        case "Store": storeButton.buttonColor = "#25FFFFFF"; break;
        case "Wallet": walletButton.buttonColor = "#25FFFFFF"; break;
        case "Settings": settingsButton.buttonColor = "#25FFFFFF"; break;
        }
    }

    RowLayout {
        spacing: 40
        anchors.centerIn: parent

        ToolBarButton  {
            id: storeButton
            text: qsTr("Store")
            source: "qrc:/imgs/storeIos.png"
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

    function crearSelection(){
        storeButton.buttonColor = "transparent"
        walletButton.buttonColor = "transparent"
        settingsButton.buttonColor = "transparent"
    }
}
