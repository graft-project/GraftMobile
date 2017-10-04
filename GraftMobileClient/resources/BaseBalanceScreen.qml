import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import com.graft.design 1.0
import "components"

BaseScreen {
    id: root

    property alias splitterVisible: splitter.visible
    default property alias content: placeholder.data

    title: qsTr("Wallet")
    screenHeader {
        navigationButtonState: true
    }

    Rectangle {
        anchors.fill: parent
        color: "#FFFFFF"

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 150
                Layout.alignment: Qt.AlignTop
                color: "#EDEEF0"

                Image {
                    id: graftWalletLogo
                    anchors.centerIn: parent
                    height: parent.height / 2
                    width: parent.width / 2
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/imgs/graft-wallet-logo.png"
                }
            }

            BalanceViewItem {
                Layout.fillWidth: true
                amountMoneyCost: 145
                amountGraftCost: "1.14"
            }

            Rectangle {
                id: splitter
                Layout.fillWidth: true
                Layout.preferredHeight: 2
                color: "#EDEEF0"
            }

            Item {
                id: placeholder
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
}
