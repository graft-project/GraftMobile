import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.device.platform 1.0
import com.graft.design 1.0
import org.navigation.attached.properties 1.0
import "components"

BaseScreen {
    id: baseScreen

    property alias amountUnlockGraft: balanceItem.amountUnlockGraftCost
    property alias amountLockGraft: balanceItem.amountLockGraftCost
    property alias graftWalletLogo: graftWalletLogo.source
    default property alias content: placeholder.data

    title: qsTr("Wallet")
    screenHeader {
        isNavigationButtonVisible: Detector.isPlatform(Platform.Android)
        navigationButtonState: true
    }
    Navigation.implicitFirstComponent: balanceItem.Navigation.implicitFirstComponent

    onReplyOnFocusReason: disableVisualFocus(balanceItem.Navigation.implicitFirstComponent)

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
                }
            }

            NetworkIndicator {
                Layout.fillWidth: true

                Label {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: 18
                    }
                    color: "#FFFFFF"
                    font.pixelSize: 16
                    text: qsTr("Version %1").arg(GraftClient.versionNumber())
                }
            }

            BalanceViewItem {
                id: balanceItem
                Layout.fillWidth: true
                Navigation.explicitLastComponent: baseScreen.Navigation.explicitLastComponent
            }

            Item {
                id: placeholder
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
}
