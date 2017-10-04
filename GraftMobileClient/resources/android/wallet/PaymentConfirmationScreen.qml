import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import "../"
import "../components"

BasePaymentConfirmationScreen {
    id: root

    Pane {
        id: totalPriceLabel
        height: 50
        width: parent.width
        anchors.top: parent.top
        Material.background: ColorFactory.color(DesignFactory.CircleBackground)
        Material.elevation: 4

        Text {
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            color: "#ffffff"
            text: qsTr("Total Checkout: ") + totalAmount + '$'
        }
    }

    ColumnLayout {
        anchors {
            top: totalPriceLabel.bottom
            topMargin: 10
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
                topLineVisible: false
                bottomLineVisible: false
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 0

            Button {
                Layout.preferredWidth: parent.width / 2.5
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
