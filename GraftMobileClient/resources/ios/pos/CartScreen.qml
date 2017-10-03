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
    screenHeader {
        navigationButtonState: true
        actionButtonState: true
        actionText: qsTr("Clear")
    }

    ColumnLayout {
        spacing: 0
        anchors.fill: parent

        Pane {
            height: 120
            Material.background: ColorFactory.color(DesignFactory.CircleBackground)
            anchors {
                right: parent.right
                left: parent.left
                top: parent.top
            }

            Label {
                text: qsTr("Total checkout: ") + price + "$"
                font.pointSize: 18
                color: "#ffffff"
                anchors.centerIn: parent
            }
        }

        Image {
            cache: false
            source: GraftClient.qrCodeImage()
            Layout.alignment: Qt.AlignCenter
            Layout.preferredHeight: 180
            Layout.preferredWidth: height
            Layout.topMargin: 25
        }

        Text {
            text: qsTr("SCAN WITH WALLET")
            Layout.alignment: Qt.AlignCenter
            font {
                bold: true
                pointSize: 16
            }
        }

        ListView {
            id: productList
            spacing: 0
            clip: true
            model: SelectedProductModel
            delegate: productDelegate
            Layout.fillWidth: true
            Layout.preferredHeight: 185
            Layout.topMargin: 25

            Component {
                id: productDelegate
                SelectedProductDelegate {
                    width: productList.width
                    height: 60
                    bottomLineVisible: index === (productList.count - 1)
                    productImage: imagePath
                    productPrice: cost
                    productPriceTextColor: ColorFactory.color(DesignFactory.ItemText)
                    productText {
                        font.bold: true
                        text: name
                        color: ColorFactory.color(DesignFactory.ProductText)
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
