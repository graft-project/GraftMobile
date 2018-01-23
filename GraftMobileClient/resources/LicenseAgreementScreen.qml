import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import com.graft.design 1.0
import com.device.detector 1.0
import "components"

BaseScreen {
    id: root
    screenHeader.visible: false
    property string logoImage
    property var acceptAction: null

    Rectangle {
        anchors.fill: parent
        color: "#FFFFFF"

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Device.detectDevice() === DeviceDetector.IPhoneX ? 44 : 20
                Layout.alignment: Qt.AlignTop
                color: ColorFactory.color(DesignFactory.IosNavigationBar)
                visible: Qt.platform.os === "ios"
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                Layout.alignment: Qt.AlignTop
                Layout.margins: 10
                Layout.topMargin: 20
                color: "transparent"

                Image {
                    id: graftWalletLogo
                    anchors.centerIn: parent
                    height: parent.height
                    width: parent.width
                    fillMode: Image.PreserveAspectFit
                    source: logoImage
                }
            }

            Label {
                Layout.fillWidth: true
                Layout.margins: 10
                horizontalAlignment: Qt.AlignCenter
                wrapMode: Label.WordWrap
                font.bold: true
                text: qsTr("GRAFT Payments, LLC\nEND USER LICENSE AGREEMENT")
            }

            Flickable {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                Layout.bottomMargin: 15
                ScrollBar.vertical: ScrollBar {
                    width: 5
                }
                clip: true

                contentHeight: licenseText.height

                Item {
                    id: licenseText
                    width: root.width - 45
                    height: Qt.platform.os === "ios" ? 750 : 710

                    Label {
                        id: mainText
                        anchors {
                            left: parent.left
                            right: parent.right
                            top: parent.top
                            leftMargin: 20
                        }

                        wrapMode: Label.WordWrap
                        text: qsTr("The Graft Wallet is provided to you free of charge to allow " +
                                   "you to access the Graft Blockchain. Graft is not responsible " +
                                   "for any loss of use or loss of funds, and some of the " +
                                   "technology we use is still under active development and " +
                                   "testing. Use the Graft Wallet at your own risk, and please " +
                                   "do not invest more than you are willing to lose.\n\n" +
                                   "You are responsible for the safety of your wallet and the " +
                                   "protection of your username and password. Always backup your " +
                                   "keys: The Graft Wallets are not exchange accounts, and we do " +
                                   "not hold funds for you. No data leaves your computer or your " +
                                   "web browser. The Graft Wallet allows you to access and " +
                                   "interact with the Graft Blockchain directly, but it does not " +
                                   "copy or retain your information. If you lose your wallet or " +
                                   "your access key, you will lose any funds associated with " +
                                   "that wallet.\n\n" +
                                   "Permission is hereby granted, free of charge, to any person " +
                                   "obtaining a copy of the Graft Wallet software and associated " +
                                   "documentation files (the \"Software\"), to deal in the " +
                                   "Software without restriction, including without limitation " +
                                   "the rights to use, copy, modify, merge, publish, distribute, " +
                                   "sublicense, and/or sell copies of the Software, and to " +
                                   "permit persons to whom the Software is furnished to do so, " +
                                   "subject to the following conditions:\n")
                    }

                    Label {
                        anchors {
                            left: parent.left
                            right: parent.right
                            top: mainText.bottom
                            bottom: parent.bottom
                        }

                        wrapMode: Label.WordWrap
                        text: qsTr("THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY " +
                                   "KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE " +
                                   "WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR " +
                                   "PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS " +
                                   "OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR " +
                                   "OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR " +
                                   "OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE " +
                                   "SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.")
                    }
                }

            }

            WideActionButton {
                id: payButton
                text: qsTr("Accept")
                Layout.leftMargin: 15
                Layout.rightMargin: 15
                Layout.bottomMargin: Device.detectDevice() === DeviceDetector.IPhoneX ? 30 : 15
                onClicked: acceptAction()
            }
        }
    }
}
