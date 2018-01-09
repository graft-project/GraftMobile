import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import "components"

BaseScreen {
    title: qsTr("Select Newtork Type")
    screenHeader.isNavigationButtonVisible: false

    ColumnLayout {
        spacing: 0
        anchors {
            fill: parent
            margins: 15
        }

        RadioButton {
            id: mainNet
            Layout.alignment: Qt.AlignTop
            Material.accent: ColorFactory.color(DesignFactory.Foreground)
            text: qsTr("Mainnet")
        }

        RadioButton {
            id: testNet
            Layout.alignment: Qt.AlignTop
            Material.accent: ColorFactory.color(DesignFactory.Foreground)
            text: qsTr("Public Testnet")
        }

        RadioButton {
            id: rtaTestNet
            Layout.alignment: Qt.AlignTop
            Material.accent: ColorFactory.color(DesignFactory.Foreground)
            text: qsTr("Public RTA Testnet")
        }

        Item {
            Layout.fillHeight: true
        }

        WideActionButton {
            Layout.alignment: Qt.AlignBottom
            text: qsTr("Confirm")
            onClicked: {
                setNetworkType()
                pushScreen.openCreateWalletScreen()
            }
        }
    }

    function setNetworkType() {
        if (mainNet.checked) {
            GraftClient.setNetworkType(0)
        } else if (testNet.checked) {
            GraftClient.setNetworkType(1)
        } else if (rtaTestNet.checked) {
            GraftClient.setNetworkType(2)
        }
    }
}
