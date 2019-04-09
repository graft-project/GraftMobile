import QtQuick 2.9
import QtQuick.Layouts 1.3
import com.device.platform 1.0
import "../components"

BaseGraftToolBar {
    onSeclectedButtonChanged: {
        clearSelection()
        switch (buttonName) {
            case "Store": storeButton.buttonColor = highlight; break;
            case "Wallet": walletButton.buttonColor = highlight; break;
            case "Settings": settingsButton.buttonColor = highlight; break;
        }
    }

    RowLayout {
        spacing: (parent.width - storeButton.width * 4) / 4
        anchors {
            topMargin: Detector.isSpecialTypeDevice() ? 3 : 0
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }

        ToolBarButton  {
            id: storeButton
            text: qsTr("Store")
            source: "qrc:/imgs/storeIos.png"
            buttonColor: highlight
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
            onClicked: pushScreen.openBlogScreen()
        }
    }

    function clearSelection() {
        var dafaultColor = "transparent"
        storeButton.buttonColor = dafaultColor
        walletButton.buttonColor = dafaultColor
        settingsButton.buttonColor = dafaultColor
    }
}
