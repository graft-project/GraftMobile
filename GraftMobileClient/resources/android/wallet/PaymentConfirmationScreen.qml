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
            Material.elevation: 5

            Text {
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
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
                topLineVisible: false
                bottomLineVisible: false
            }
        }

        RowLayout {
            id: bottomButtons
            width: parent.width
            anchors {
                bottom: parent.bottom
                bottomMargin: 10
            }
            spacing: 0

            Button {
                Layout.preferredWidth: productList.width / 2.75
                flat: true
                text: qsTr("CANCEL")
                onClicked: cancelPay()
            }

            WideActionButton {
                text: qsTr("CONFIRM")
                onClicked: confirmPay()
            }
        }
    }
}
