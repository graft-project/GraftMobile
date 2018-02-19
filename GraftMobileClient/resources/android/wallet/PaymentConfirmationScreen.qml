import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import "../components"
import "../"

BasePaymentConfirmationScreen {
    id: root
    onErrorMessage: busyIndicator.running = false

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#FFFFFF"

        ListView {
            id: productList
            anchors {
                top: parent.top
                topMargin: 10
                bottom: quickExchangeView.top
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

        QuickExchangeView {
            id: quickExchangeView
            height: 50
            anchors {
                left: parent.left
                right: parent.right
                bottom: bottomButtons.top
                bottomMargin: 15
            }
        }

        RowLayout {
            id: bottomButtons
            spacing: 10
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                leftMargin: 15
                rightMargin: 15
                bottomMargin: 15
            }

            Button {
                Layout.alignment: Qt.AlignLeft
                Layout.preferredWidth: productList.width / 2.75
                flat: true
                text: qsTr("CANCEL")
                onClicked: {
                    root.disableScreen()
                    cancelPay()
                }
            }

            WideActionButton {
                text: qsTr("CONFIRM")
                Layout.alignment: Qt.AlignRight
                onClicked: {
                    busyIndicator.running = true
                    confirmPay()
                }
            }
        }
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: false
    }
}
