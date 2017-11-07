import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import "../components"
import "../"

BasePaymentConfirmationScreen {
    id: root

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#FFFFFF"

        /*
        Pane {
            id: totalPriceLabel

            height: 50
            anchors {
                right: parent.right
                left: parent.left
                top: parent.top
            }
            Material.elevation: 5
            padding: 0

            contentItem: Rectangle {
                color: ColorFactory.color(DesignFactory.CircleBackground)

                Text {
                    id: completeLabelText
                    anchors {
                        left: parent.left
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        leftMargin: 12
                    }
                    horizontalAlignment: Text.AlignLeft
                    color: "#FFFFFF"
                    text: qsTr("Total Checkout: %1$").arg(totalAmount)
                }
            }
        }
        */

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
            width: parent.width
        }

        RowLayout {
            id: bottomButtons
            spacing: 0
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
                onClicked: cancelPay()
            }

            WideActionButton {
                text: qsTr("CONFIRM")
                Layout.alignment: Qt.AlignRight
                onClicked: {
                    root.state = "beforePaid"
                    confirmPay()
                }
            }
        }
    }

    BusyIndicator {
        id: busyIndicator
        visible: false
        running: false
        anchors {
            centerIn: parent
        }
    }

    states: [
        State {
            name: "beforePaid"
            PropertyChanges {
                target: busyIndicator
                visible: true
                running: true
            }
            PropertyChanges {
                target: background
                enabled: false
            }
        }
    ]
}
