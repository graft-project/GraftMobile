import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import "../components"
import "../"

BaseCartScreen {
    id: cartScreen

    onScreenClosed: {
        busyIndicator.running = false
    }

    Rectangle {
        anchors.fill: parent
        color: "#e9e9e9"

        ColumnLayout {
            anchors.fill: parent
            spacing: 11

            Image {
                cache: false
                source: GraftClient.qrCodeImage()
                Layout.alignment: Qt.AlignCenter
                Layout.preferredHeight: 160
                Layout.preferredWidth: height
                Layout.topMargin: 10
            }

            Text {
                text: qsTr("SCAN WITH WALLET")
                font {
                    bold: true
                    pixelSize: 16
                }
                color: ColorFactory.color(DesignFactory.Foreground)
                Layout.alignment: Qt.AlignCenter
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0

                Rectangle {
                    color: "#ffffff"
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    ListView {
                        id: productList
                        spacing: 0
                        clip: true
                        model: SelectedProductModel
                        delegate: productDelegate
                        anchors.fill: parent

                        Component {
                            id: productDelegate

                            SelectedProductDelegate {
                                width: productList.width
                                height: 70
                                topLineVisible: false
                                bottomLineVisible: false
                                productImage: imagePath
                                productPrice: cost
                                productPriceTextColor: ColorFactory.color(
                                                           DesignFactory.ItemText)
                                productText {
                                    text: name
                                    color: ColorFactory.color(
                                               DesignFactory.MainText)
                                }
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
                    Layout.preferredHeight: 50
                    Layout.fillWidth: true
                    Layout.bottomMargin: 4
                }
            }

            WideActionButton {
                text: qsTr("Cancel")
                Material.accent: ColorFactory.color(DesignFactory.LightButton)
                Layout.leftMargin: 15
                Layout.rightMargin: 15
                Layout.bottomMargin: 15
                onClicked: cartScreen.rejectSale()
            }
        }
    }
}
