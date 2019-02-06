import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import "../components"
import "../"

BaseCartScreen {
    id: cartScreen
    action: cartScreen.rejectSale
    screenHeader {
        actionButtonState: true
        actionText: qsTr("Clear")
    }

    onScreenClosed: {
        busyIndicator.running = false
    }

    Rectangle {
        anchors.fill: parent
        color: "#ffffff"

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            QRCodeImage {
                id: image
                Layout.alignment: Qt.AlignCenter
                Layout.preferredHeight: image.defaultSize
                Layout.preferredWidth: image.defaultSize
                bottomHeight: info.implicitHeight - 5 + exchangeView.implicitHeight + cancelButton.implicitHeight
                Layout.topMargin: 25
            }

            Label {
                id: info
                Layout.alignment: Qt.AlignCenter
                font {
                    bold: true
                    pixelSize: 16
                }
                text: qsTr("SCAN WITH WALLET")
            }

            ListView {
                id: productList
                spacing: 0
                clip: true
                model: SelectedProductModel
                delegate: productDelegate
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.topMargin: 25

                Component {
                    id: productDelegate

                    SelectedProductDelegate {
                        width: productList.width
                        height: 60
                        bottomLineVisible: index === (productList.count - 1)
                        productImage: imagePath
                        productPrice: cost
                        productPriceTextColor: ColorFactory.color(
                                                   DesignFactory.ItemText)
                        productText {
                            font.bold: true
                            text: name
                            color: ColorFactory.color(DesignFactory.ProductText)
                        }
                    }
                }

                BusyIndicator {
                    id: busyIndicator
                    anchors.centerIn: parent
                    running: true
                }
            }

            QuickExchangeView {
                id: exchangeView
                Layout.preferredHeight: 50
                Layout.fillWidth: true
                Layout.bottomMargin: 15
            }

            WideActionButton {
                id: cancelButton
                text: qsTr("Cancel")
                Material.accent: ColorFactory.color(DesignFactory.LightButton)
                Layout.leftMargin: 15
                Layout.rightMargin: 15
                Layout.bottomMargin: 15
                onClicked: {
                    cartScreen.disableScreen()
                    cartScreen.rejectSale()
                }
            }
        }
    }
}
