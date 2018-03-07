import QtQuick 2.9
import QtQuick.Layouts 1.3
import com.device.platform 1.0
import com.graft.design 1.0
import "components"

BaseScreen {
    property alias amountUnlockGraft: balanceItem.amountUnlockGraftCost
    property alias amountLockGraft: balanceItem.amountLockGraftCost
    property alias graftWalletLogo: graftWalletLogo.source
    default property alias content: placeholder.data

    title: qsTr("Wallet")
    screenHeader {
        isNavigationButtonVisible: Detector.isPlatform(Platform.Android)
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
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/imgs/graft-wallet-logo.png"

                    Text {
                        anchors{
                            rightMargin: Detector.isDesktop() ? -10 : 0
                            right: parent.right
                            baseline: parent.bottom
                        }
                        font {
                            pixelSize: 18
                            italic: true
                            bold: true
                        }
                        color: ColorFactory.color(DesignFactory.AndroidStatusBar)
                        text: qsTr("Ver. %1").arg(GraftClient.versionNumber())
                    }
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
