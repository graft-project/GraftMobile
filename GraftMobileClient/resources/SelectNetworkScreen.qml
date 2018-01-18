import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import "components"

BaseScreen {
    title: qsTr("Select Network")
    screenHeader.isNavigationButtonVisible: false

    Component.onCompleted: mainNet.checked = true

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
            text: qsTr("Actual GRAFT blockchain, production network. This is the blockchain " +
                       "that carry real GRF transactions.")
            MouseArea {
                anchors.fill: parent
                onClicked: mainNet.checked = true
            }
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
            text: qsTr("Exact functional copy of mainnet for public testing of mining, " +
                       "supernodes, wallet apps, and other features of GRAFT ecosystem.")
            MouseArea {
                anchors.fill: parent
                onClicked: testNet.checked = true
            }
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
            text: qsTr("Blockchain and test network running on the code branch that contains " +
                       "Real Time Authorization and other future features that are not yet " +
                       "available on mainnet.")
            MouseArea {
                anchors.fill: parent
                onClicked: rtaTestNet.checked = true
            }
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
