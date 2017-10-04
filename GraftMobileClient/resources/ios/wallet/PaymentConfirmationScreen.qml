import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import "../"
import "../components"

BasePaymentConfirmationScreen {
    id: root

    property real totalAmount: 0
    property alias productModel: productList.model

    Rectangle {
        id: totalPriceLabel
        anchors.top: parent.top
        width: parent.width
        height: 50
        color: ColorFactory.color(DesignFactory.CircleBackground)

        Text {
            anchors.centerIn: parent
            color: "#ffffff"
            text: qsTr("Total Checkout: ") + totalAmount + '$'
        }
    }

    ColumnLayout {
        anchors {
            top: totalPriceLabel.bottom
            bottom: parent.bottom
        }
        width: parent.width

        ListView {
            id: productList
            Layout.fillHeight: true
            Layout.fillWidth: true
            clip: true
            delegate: SelectedProductDelegate {
                height: 50
                parent: productList
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: 12
                    rightMargin: 12
                }
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
