import QtQuick 2.9
import QtQuick.Layouts 1.3
import com.device.platform 1.0
import "../components"

BaseGraftToolBar {
    onSeclectedButtonChanged: {
        clearSelection()
        switch (buttonName) {
            case "Wallet": walletButton.buttonColor = highlight; break;
            case "Transaction": transactionButton.buttonColor = highlight; break;
            case "Transfer": transferButton.buttonColor = highlight; break;
            case "Settings": settingsButton.buttonColor = highlight; break;
        }
    }

    RowLayout {
        spacing: (parent.width - walletButton.width * 5) / 5
        anchors {
            topMargin: Detector.detectDevice() === Platform.IPhoneX ? 3 : 0
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }

        ToolBarButton  {
            id: walletButton
            text: qsTr("Wallet")
            source: "qrc:/imgs/walletIos.png"
            buttonColor: highlight
            onClicked: pushScreen.openMainScreen()
        }

        ToolBarButton {
            id: transactionButton
            text: qsTr("Transaction")
            source: "qrc:/imgs/transactionIos.png"
            enabled: false
            opacity: 0.2
            onClicked: pushScreen.openTransactionScreen()
        }

        ToolBarButton {
            id: transferButton
            text: qsTr("Transfer")
            source: "qrc:/imgs/transferIos.png"
            enabled: false
            opacity: 0.2
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
        var dafaultColor = "transparent"
        walletButton.buttonColor = dafaultColor
        transactionButton.buttonColor = dafaultColor
        transferButton.buttonColor = dafaultColor
        settingsButton.buttonColor = dafaultColor
    }
}
