import QtQuick 2.9
import QtQuick.Layouts 1.3
import "components"

BaseScreen {
    property alias amountUnlockGraft: balanceItem.amountUnlockGraftCost
    property alias amountLockGraft: balanceItem.amountLockGraftCost
    property alias graftWalletLogo: graftWalletLogo.source
    default property alias content: placeholder.data

    title: qsTr("Wallet")
    screenHeader {
        isNavigationButtonVisible: false
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

            NetworkIndicator {
                Layout.fillWidth: true
            }

            BalanceViewItem {
                id: balanceItem
                Layout.fillWidth: true
            }

            Item {
                id: placeholder
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
}
