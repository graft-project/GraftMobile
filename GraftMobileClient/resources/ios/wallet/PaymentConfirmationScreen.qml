import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import "../components"
import "../"

BasePaymentConfirmationScreen {
    id: root

    property bool paymentState: false

    onErrorMessage: busyIndicator.running = false

    Component.onCompleted: {
        if (paymentState) {
            root.state = "processing"
        } else {
            root.state = "done"
        }
    }

    Connections {
        target: GraftClient

        onSaleDetailsReceived: {
            if (result === true) {
                console.log("=============On the base screen=============")
                paymentState = false
            }
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#FFFFFF"

        ListView {
            id: productList
            anchors {
                top: parent.top
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
                topLineVisible: true
                bottomLineVisible: (index >= 0 && index < (productList.count - 1)) ? false : true
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

        ColumnLayout {
            id: bottomButtons
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                leftMargin: 15
                rightMargin: 15
                bottomMargin: 15
            }
            spacing: 0

            WideActionButton {
                id: cancelButton
                text: qsTr("Cancel")
                Material.accent: "#7E726D"
                onClicked: {
                    root.disableScreen()
                    cancelPay()
                }
            }

            WideActionButton {
                id: payButton
                text: qsTr("Pay")
                onClicked: {
                    busyIndicator.running = true
                    confirmPay()
                }
            }
        }
    }

    states: [
        State {
            name: "done"
            PropertyChanges {
                target: payButton
                enabled: true
            }
            PropertyChanges {
                target: cancelButton
                enabled: true
            }
            PropertyChanges {
                target: labelText
                visible: false
            }
            PropertyChanges {
                target: busyInd
                running: false
            }
        },
        State {
            name: "processing"
            PropertyChanges {
                target: payButton
                enabled: false
            }
            PropertyChanges {
                target: cancelButton
                enabled: false
            }
            PropertyChanges {
                target: labelText
                visible: true
            }
            PropertyChanges {
                target: busyInd
                running: true
            }
        }
    ]

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: false
    }

    Label {
        id: labelText
        anchors.centerIn: parent
        color: "#000000"
        font.pixelSize: 17
        visible: false
        text: qsTr("Waiting for payment details...")
    }

    BusyIndicator {
        id: busyInd
        anchors.centerIn: parent
        running: false
    }
}
