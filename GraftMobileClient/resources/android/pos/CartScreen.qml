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
            spacing: 0
            anchors.fill: parent

            Pane {
                height: 120
                anchors {
                    right: parent.right
                    left: parent.left
                    top: parent.top
                }
                Material.background: ColorFactory.color(DesignFactory.CircleBackground)
                Material.elevation: 8

                Label {
                    text: qsTr("Total checkout: ") + price + "$"
                    font.pointSize: 18
                    color: "#ffffff"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Image {
                cache: false
                source: GraftClient.qrCodeImage()
                Layout.alignment: Qt.AlignCenter
                Layout.preferredHeight: 180
                Layout.preferredWidth: height
            }

            Text {
                text: qsTr("SCAN WITH WALLET")
                font.pointSize: 16
                Layout.alignment: Qt.AlignCenter
            }

            Rectangle {
                color: "#ffffff"
                Layout.fillWidth: true
                Layout.preferredHeight: 185

                ListView {
                    id: productList
                    spacing: 0
                    clip: true
                    model: SelectedProductModel
                    delegate: productDelegate
                    anchors.fill: parent

                    Component {
                        id: productDelegate
                        ProductSwipeDelegate {
                            width: productList.width
                            height: 60
                            visibleCheckBox: false
                            swipe.enabled: false
                            bottomLineVisible: false
                            topLineVisible: false
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
                Material.accent: "#7e726d"
                Layout.bottomMargin: 5
                onClicked: cardScreen.rejectSale()
            }
        }
    }
}
