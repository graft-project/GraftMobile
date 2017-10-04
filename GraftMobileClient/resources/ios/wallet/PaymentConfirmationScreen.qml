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
        id: totalPriceLabel
        height: 50
        width: parent.width
        anchors.top: parent.top
        color: ColorFactory.color(DesignFactory.CircleBackground)

        Text {
            anchors.centerIn: parent
            color: "#ffffff"
            text: "%1%2%3".arg(qsTr("Total Checkout: ")).arg(totalAmount).arg('$')
        }
    }

    ColumnLayout {
        anchors {
            top: totalPriceLabel.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        ListView {
            id: productList
            Layout.fillHeight: true
            Layout.fillWidth: true
            clip: true
            model: productModel
            delegate: SelectedProductDelegate {
                height: 50
                width: productList.width
                visibleProductImage: false
                productText.text: name
                productPrice: cost
                productPriceTextColor: "#797979"
                topLineVisible: true
                bottomLineVisible: (index >= 0 && index < (productList.count - 1)) ? false : true
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            WideActionButton {
                Layout.preferredWidth: parent.width / 2.5
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
