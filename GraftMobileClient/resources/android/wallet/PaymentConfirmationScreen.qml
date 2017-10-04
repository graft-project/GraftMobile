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

    Pane {
        id: totalPriceLabel
        height: 50
        anchors {
            right: parent.right
            left: parent.left
            top: parent.top
        }
        Material.background: ColorFactory.color(DesignFactory.CircleBackground)
        Material.elevation: 4

        Text {
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: 12
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
