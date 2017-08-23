import QtQml 2.2
import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
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
                pushScreen()
            }
        }
        onPayStatusReceived: {
            if (result === true) {
                root.state = "afterPaid"
            }
            else {
                pushScreen()
            }
        }
    }

    ListModel {
        id: testProductModel

        ListElement {
            name: "Hairout 1"
            cost: 20
        }

        ListElement {
            name: "Hairout 2"
            cost: 20
        }

        ListElement {
            name: "Hairout 3"
            cost: 20
        }

        ListElement {
            name: "Hairout 4"
            cost: 20
        }

        ListElement {
            name: "Hairout 5"
            cost: 20
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
                model: testProductModel
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
                color: "#d7d7d7"
            }

            TotalView {
                Layout.topMargin: 7
                id: totalViewItem
                Layout.preferredWidth: parent.width
            }
        }

        StackLayout {
            id: stack
            currentIndex: 0
            Layout.maximumHeight: childrenRect.height

            ColumnLayout {
                spacing: 50
                CurrencySelectionItem {
                    id: currencyItem
                    Layout.fillWidth: true
                }

                WideRoundButton {
                    id: confirmButton
                    text: qsTr("Confirm")
                    onClicked: {
                        GraftClient.pay()
                    }
                }
            }

            ColumnLayout {
                Layout.preferredHeight: parent.height
                Layout.preferredWidth: parent.width

                Image {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    source: "qrc:/imgs/paid_icon.png"
                    Layout.preferredHeight: 150
                    Layout.preferredWidth: 150
                }

                Text {
                    Layout.alignment: Qt.AlignCenter
                    font.pointSize: 20
                    color: "#707070"
                    text: qsTr("PAID !")
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
