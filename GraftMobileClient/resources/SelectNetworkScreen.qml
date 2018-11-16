import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.device.platform 1.0
import "components"

BaseScreen {
    title: qsTr("Select Network")
    screenHeader {
        isNavigationButtonVisible: false
        navigationButtonState: true
    }
    Component.onCompleted: mainNet.networkChecked = true

    Item {
        anchors.fill: parent

        ColumnLayout {
            spacing: 25
            anchors {
                fill: parent
                topMargin: 15
                leftMargin: 15
                rightMargin: 15
                bottomMargin: Detector.detectDevice() === Platform.IPhoneX ? 30 : 15
            }

            NetworkType {
                id: mainNet
                Layout.alignment: Qt.AlignTop
                Layout.preferredHeight: parent / 3
                type: qsTr("Mainnet")
                networkDescription: qsTr("Actual GRAFT blockchain, production network. This is the blockchain " +
                                         "that carry real GRFT transactions.")
                onTypeSelected: {
                    networkChecked = true
                    testNet.networkChecked = false
                    rtaTestNet.networkChecked = false
                }
            }

            NetworkType {
                id: testNet
                Layout.alignment: Qt.AlignTop
                Layout.preferredHeight: parent / 3
                type: qsTr("Public Testnet")
                networkDescription: qsTr("Exact functional copy of mainnet for public testing of mining, " +
                                         "supernodes, wallet apps, and other features of GRAFT ecosystem.")
                onTypeSelected: {
                    networkChecked = true
                    mainNet.networkChecked = false
                    rtaTestNet.networkChecked = false
                }
            }

            NetworkType {
                id: rtaTestNet
                Layout.alignment: Qt.AlignTop
                Layout.preferredHeight: parent / 3
                type: qsTr("Alpha RTA Testnet")
                networkDescription: qsTr("Blockchain and test network running on the code branch that contains " +
                                         "Real Time Authorization and other future features that are not yet " +
                                         "available on mainnet.\n\nCurrently available only for iOS and MacOS.\n" +
                                         "Other platforms are coming soon.")
                onTypeSelected: {
                    networkChecked = true
                    mainNet.networkChecked = false
                    testNet.networkChecked = false
                }
            }

            Item {
                Layout.fillHeight: true
            }

            WideActionButton {
                Layout.alignment: Qt.AlignBottom
                text: qsTr("Confirm")
                enabled: Detector.isPlatform(Platform.IOS) || Detector.isPlatform(Platform.MacOS)
                         ? true : !rtaTestNet.networkChecked
                onClicked: {
                    disableScreen()
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
}
