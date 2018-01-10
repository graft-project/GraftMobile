import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import "components"

BaseScreen {
    title: qsTr("Select Network")
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
            Material.foreground: ColorFactory.color(DesignFactory.Foreground)
            text: qsTr("Mainnet")
            font {
                pointSize: 16
                bold: true
            }
        }

        Label {
            Layout.fillWidth: true
            Layout.leftMargin: 35
            Layout.rightMargin: 20
            color: "#BBBBBB"
            font.pointSize: 14
            wrapMode: Label.WordWrap
            text: qsTr("The production network with real coins.")
        }

        RadioButton {
            id: testNet
            Layout.alignment: Qt.AlignTop
            Material.accent: ColorFactory.color(DesignFactory.Foreground)
            Material.foreground: ColorFactory.color(DesignFactory.Foreground)
            text: qsTr("Public Testnet")
            font {
                pointSize: 16
                bold: true
            }
        }

        Label {
            Layout.fillWidth: true
            Layout.leftMargin: 35
            Layout.rightMargin: 20
            color: "#BBBBBB"
            font.pointSize: 14
            wrapMode: Label.WordWrap
            text: qsTr("The public test network for beginners which want to " +
                       "try how Graft Ecosystem is working.")
        }

        RadioButton {
            id: rtaTestNet
            Layout.alignment: Qt.AlignTop
            Material.accent: ColorFactory.color(DesignFactory.Foreground)
            Material.foreground: ColorFactory.color(DesignFactory.Foreground)
            text: qsTr("Public RTA Testnet")
            font {
                pointSize: 16
                bold: true
            }
        }

        Label {
            Layout.fillWidth: true
            Layout.leftMargin: 35
            Layout.rightMargin: 20
            Layout.minimumHeight: 35
            color: "#BBBBBB"
            font.pointSize: 14
            wrapMode: Label.WordWrap
            text: qsTr("The public experimental test network which provides the unreleased" +
                       " version of Real-Time Authorization functionality.")
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
