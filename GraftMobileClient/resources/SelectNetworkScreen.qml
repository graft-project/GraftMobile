import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import com.device.platform 1.0
import org.graft 1.0
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
            spacing: 10
            anchors {
                fill: parent
                topMargin: 15
                leftMargin: 15
                rightMargin: 15
                bottomMargin: Detector.detectDevice() === Platform.IPhoneX ? 30 : 15
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

                    NetworkType {
                        id: mainNet
                        Layout.alignment: Qt.AlignTop
                        Layout.preferredHeight: implicitHeight
                        type: qsTr("Mainnet")
                        networkDescription: GraftClientConstants.mainnetDescription()
                        onTypeSelected: {
                            networkChecked = true
                            testNet.networkChecked = false
                            rtaTestNet.networkChecked = false
                        }
                    }

                    NetworkType {
                        id: testNet
                        Layout.alignment: Qt.AlignTop
                        Layout.preferredHeight: implicitHeight
                        type: qsTr("Public Testnet")
                        networkDescription: GraftClientConstants.publicTestnetDescription()
                        onTypeSelected: {
                            networkChecked = true
                            mainNet.networkChecked = false
                            rtaTestNet.networkChecked = false
                        }
                    }

                    NetworkType {
                        id: rtaTestNet
                        Layout.alignment: Qt.AlignTop
                        Layout.preferredHeight: implicitHeight
                        type: qsTr("Alpha RTA Testnet")
                        networkDescription: GraftClientConstants.alphaRTATestnetDescription()
                        onTypeSelected: {
                            networkChecked = true
                            mainNet.networkChecked = false
                            testNet.networkChecked = false
                        }
                    }
                }
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
