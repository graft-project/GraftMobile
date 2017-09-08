import QtQml 2.2
import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import com.graft.design 1.0
import "../"
import "../components"

BaseScreen {
    id: root
    property alias totalAmount: totalViewItem.totalAmount
    property alias currencyModel: currencyItem.currencyModel
    property alias balanceInGraft: currencyItem.balanceInGraft
    property alias balanceInUSD: currencyItem.balanceInUSD
    property alias productModel: productList.model

    title: qsTr("Pay")

    Connections {
        target: GraftClient

        onPayReceived: {
            if (result === true) {
                root.state = "beforePaid"
            }
            else {
                pushScreen.openBalanceScreen()
            }
        }
        onPayStatusReceived: {
            if (result === true) {
                root.state = "afterPaid"
            }
            else {
                pushScreen.openBalanceScreen()
            }
        }
    }

    ColumnLayout {
        id: column
        anchors {
            leftMargin: 30
            rightMargin: 30
            topMargin: 10
            bottomMargin: 20
            fill: parent
        }
        spacing: 40

        ColumnLayout {
            Layout.leftMargin: 5
            Layout.rightMargin: 5
            Layout.fillHeight: true
            Layout.fillWidth: true

            ListView {
                id: productList
                Layout.fillHeight: true
                Layout.fillWidth: true
                clip: true
                delegate: SelectedProductDelegate {
                    width: productList.width
                    productName: name
                    price: cost
                    lineVisible: index !== (productList.count - 1)
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 2
                color: ColorFactory.color(DesignFactory.AllocateLine)
            }

            TotalView {
                id: totalViewItem
                Layout.topMargin: 7
                Layout.preferredWidth: parent.width
            }
        }

        StackLayout {
            id: stack
            currentIndex: 0
            Layout.maximumHeight: childrenRect.height

            ColumnLayout {
                spacing: 20

                CurrencySelectionItem {
                    id: currencyItem
                    Layout.fillWidth: true
                }

                RowLayout {
                    Layout.fillHeight: true

                    WideRoundButton {
                        id: confirmButton
                        text: qsTr("Confirm")
                        onClicked: {
                            GraftClient.pay()
                        }
                        Layout.leftMargin: 0
                        Layout.rightMargin: 0
                    }

                    WideRoundButton {
                        id: declineButton
                        text: qsTr("Cancel")
                        onClicked: {
                            GraftClient.rejectPay()
                            pushScreen.openBalanceScreen()
                        }
                        Layout.leftMargin: 0
                        Layout.rightMargin: 0
                    }
                }
            }

            ColumnLayout {
                Layout.preferredWidth: parent.width

                Image {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    source: "qrc:/imgs/paid_icon.png"
                    Layout.preferredHeight: 120
                    Layout.preferredWidth: 120
                }

                Text {
                    text: qsTr("PAID !")
                    Layout.alignment: Qt.AlignCenter
                    font.pointSize: 19
                    color: ColorFactory.color(DesignFactory.MainText)
                }
            }
        }
    }

    BusyIndicator {
        id: busyIndicator
        visible: false
        running: false
        anchors {
            verticalCenterOffset: -60
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
                target: column
                enabled: false
            }
        },
        State {
            name: "afterPaid"
            PropertyChanges {
                target: stack
                currentIndex: 1
            }
            PropertyChanges {
                target: column
                enabled: true
            }
            PropertyChanges {
                target: busyIndicator
                visible: false
            }
        }
    ]
}
