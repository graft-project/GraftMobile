import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import "../components"
import "../"

BaseCardScreen {
    id: cardScreen

    property real price: 0

    title: qsTr("Cart")

    Rectangle {
        anchors.fill: parent
        color: "#e9e9e9"

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Pane {
                anchors {
                    right: parent.right
                    left: parent.left
                    top: parent.top
                }
                height: 130
                Material.elevation: 8
                Material.background: ColorFactory.color(DesignFactory.CircleBackground)

                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Total checkout: ") + price + "$"
                    font.pointSize: 18
                    color: "#ffffff"
                }
            }

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
                    pointSize: 16
                }
                color: ColorFactory.color(DesignFactory.Foreground)
                Layout.alignment: Qt.AlignCenter
            }

            Rectangle {
                color: "#ffffff"
                Layout.fillWidth: true
                Layout.preferredHeight: 230

                ListView {
                    id: productList
                    spacing: 15
                    clip: true
                    model: SelectedProductModel
                    delegate: productDelegate
                    anchors {
                        fill: parent
                        topMargin: 8
                    }

                    Component {
                        id: productDelegate
                        SelectedProductDelegate {
                            width: productList.width
                            height: 60
                            topLineVisible: false
                            bottomLineVisible: false
                            productImage: imagePath
                            productPrice: cost
                            productPriceTextColor: ColorFactory.color(DesignFactory.ItemText)
                            productText {
                                text: name
                                color: ColorFactory.color(DesignFactory.MainText)
                            }
                        }
                    }
                }
            }

            WideActionButton {
                id: addButton
                text: qsTr("Cancel")
                Material.accent: ColorFactory.color(DesignFactory.LightButton)
                Layout.bottomMargin: 5
                onClicked: cardScreen.rejectSale()
            }
        }
    }
}
