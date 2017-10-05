import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import "../"
import "../components"

BasePaymentConfirmationScreen {
    id: root

    Rectangle {
        anchors.fill: parent
        color: "#FFFFFF"

        Pane {
            id: totalPriceLabel
            height: 50
            width: parent.width
            anchors.top: parent.top
            Material.background: ColorFactory.color(DesignFactory.CircleBackground)
            Material.elevation: 0

            Text {
                anchors {
                    centerIn: parent
                }
                color: "#FFFFFF"
                text: qsTr("Total Checkout: %1$").arg(totalAmount)
            }
        }

        ListView {
            id: productList
            anchors {
                top: totalPriceLabel.bottom
                topMargin: 10
                bottom: bottomButtons.top
                left: parent.left
                right: parent.right
            }
            clip: true
            model: productModel
            delegate: SelectedProductDelegate {
                height: 50
                width: productList.width
                productImageVisible: false
                productText.text: name
                productPrice: cost
                productPriceTextColor: "#797979"
                topLineVisible: true
                bottomLineVisible: (index >= 0 && index < (productList.count - 1)) ? false : true
            }
        }

        ColumnLayout {
            id: bottomButtons
            width: parent.width
            anchors {
                bottom: parent.bottom
                bottomMargin: 10
            }
            spacing: 0

            WideActionButton {
                text: qsTr("Cancel")
                Material.accent: "#7E726D"
                onClicked: cancelPay()
            }

            WideActionButton {
                text: qsTr("Pay")
                onClicked: confirmPay()
            }
        }
    }
}
