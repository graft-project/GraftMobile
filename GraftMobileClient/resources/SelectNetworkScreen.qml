import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.device.platform 1.0
import org.navigation.attached.properties 1.0
import org.graft 1.0
import "components"

BaseScreen {
    id: root
    title: qsTr("Select Network")
    screenHeader {
        isNavigationButtonVisible: false
        navigationButtonState: true
    }
    Navigation.explicitFirstComponent: mainNet.Navigation.implicitFirstComponent

    onReplyOnFocusReason: disableVisualFocus(mainNet.Navigation.implicitFirstComponent)
    onVisibleChanged: mainNet.networkChecked = true

    Item {
        anchors.fill: parent

        ColumnLayout {
            spacing: 10
            anchors {
                fill: parent
                topMargin: 15
                leftMargin: 15
                rightMargin: 15
                bottomMargin: Detector.bottomNavigationBarHeight() + 15
            }

            Flickable {
                Layout.fillHeight: true
                Layout.fillWidth: true
                ScrollBar.vertical: ScrollBar {
                    width: 5
                }
                flickableDirection: Flickable.AutoFlickIfNeeded
                contentHeight: networkTypes.height

                ColumnLayout {
                    id: networkTypes
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    spacing: 20

                    ButtonGroup {
                        id: networkGroup
                    }

                    NetworkType {
                        id: mainNet
                        networkChecked: true
                        Layout.alignment: Qt.AlignTop
                        Layout.preferredHeight: implicitHeight
                        type: qsTr("Mainnet")
                        group: networkGroup
                        Navigation.explicitFirstComponent: enabledConfirmButton() ? confirmButton :
                                                           rtaTestNet.Navigation.implicitFirstComponent
                        networkDescription: GraftClientConstants.mainnetDescription()
                    }

                    NetworkType {
                        id: testNet
                        Layout.alignment: Qt.AlignTop
                        Layout.preferredHeight: implicitHeight
                        type: qsTr("Public Testnet")
                        group: networkGroup
                        networkDescription: GraftClientConstants.publicTestnetDescription()
                    }

                    NetworkType {
                        id: rtaTestNet
                        Layout.alignment: Qt.AlignTop
                        Layout.preferredHeight: implicitHeight
                        type: qsTr("Public Devnet")
                        group: networkGroup
                        Navigation.explicitLastComponent: enabledConfirmButton() ? null :
                                                          mainNet.Navigation.implicitFirstComponent
                        networkDescription: GraftClientConstants.alphaRTATestnetDescription()
                    }
                }
            }

            WideActionButton {
                id: confirmButton
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignBottom | Qt.AlignCenter
                text: qsTr("Confirm")
                enabled: enabledConfirmButton()
                KeyNavigation.tab: root.Navigation.explicitFirstComponent
                onClicked: {
                    setNetworkType()
                    pushScreen.openCreateWalletScreen()
                }
            }
        }
    }

    function setNetworkType() {
        if (mainNet.networkChecked) {
            GraftClient.setNetworkType(0)
        } else if (testNet.networkChecked) {
            GraftClient.setNetworkType(1)
        } else if (rtaTestNet.networkChecked) {
            GraftClient.setNetworkType(2)
        }
    }

    function enabledConfirmButton() {
        if (Detector.isPlatform(Platform.IOS) || Detector.isPlatform(Platform.MacOS)) {
            return true
        } else {
            return !rtaTestNet.networkChecked
        }
    }
}
