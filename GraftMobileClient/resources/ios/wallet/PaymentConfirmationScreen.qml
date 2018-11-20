import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import "../components"
import "../"

BasePaymentConfirmationScreen {
    id: root
    state: "processing"

    onErrorMessage: errorIndicator.running = false

    Connections {
        target: GraftClient
        onSaleDetailsReceived: {
            if (result === true) {
                root.state = "done"
            }
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#FFFFFF"

        ListView {
            id: productList
            visible: false
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
            visible: false
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
            enabled: false
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
                text: qsTr("Cancel")
                Material.accent: "#7E726D"
                onClicked: {
                    root.disableScreen()
                    cancelPay()
                }
            }

            WideActionButton {
                text: qsTr("Pay")
                onClicked: {
                    errorIndicator.running = true
                    confirmPay()
                }
            }
        }
    }

    states: [
        State {
            name: "done"

            PropertyChanges { target: productList; visible: true }
            PropertyChanges { target: quickExchangeView; visible: true }
            PropertyChanges { target: bottomButtons; enabled: true }
            PropertyChanges { target: message; visible: false }
            PropertyChanges { target: processingIndicator; running: false }
        },
        State {
            name: "processing"

            PropertyChanges { target: productList; visible: false }
            PropertyChanges { target: quickExchangeView; visible: false }
            PropertyChanges { target: bottomButtons; enabled: false }
            PropertyChanges { target: message; visible: true }
            PropertyChanges { target: processingIndicator; running: true }
        }
    ]

    BusyIndicator {
        id: errorIndicator
        anchors.centerIn: parent
        running: false
    }

    Label {
        id: message
        visible: false
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: 30
        }
        horizontalAlignment: Label.AlignHCenter
        color: "#50000000"
        font.pixelSize: 17
        text: qsTr("Waiting for payment details...")
    }

    BusyIndicator {
        id: processingIndicator
        anchors.centerIn: parent
        running: false
    }
}
