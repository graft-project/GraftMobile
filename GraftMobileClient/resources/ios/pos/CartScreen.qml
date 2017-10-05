import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import "../components"
import "../"

BaseCartScreen {
    id: cartScreen
    screenHeader {
        navigationButtonState: true
        actionButton: true
        actionText: qsTr("Clear")
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Pane {
            anchors {
                right: parent.right
                left: parent.left
                top: parent.top
            }
            height: 120
            Material.background: ColorFactory.color(DesignFactory.CircleBackground)

            Label {
                anchors.centerIn: parent
                text: qsTr("Total checkout: %1$").arg(price)
                font.pointSize: 18
                color: "#ffffff"
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
            font {
                bold: true
                pointSize: 16
            }
            Layout.alignment: Qt.AlignCenter
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
            text: qsTr("Cancel")
            Material.accent: ColorFactory.color(DesignFactory.LightButton)
            Layout.bottomMargin: 5
            onClicked: cartScreen.rejectSale()
        }
    }
}
