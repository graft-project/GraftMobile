import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import "../components"
import "../"

BaseScreen {
    title: qsTr("Cart")
    property int price: 100
    property alias productListModel: productView.model

    ColumnLayout {
        anchors.fill: parent

        RowLayout {
            Layout.topMargin: 20
            Layout.leftMargin: 23
            Layout.rightMargin: 23
            Layout.bottomMargin: 20
            Layout.preferredWidth: parent.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

            ColumnLayout {
                id: totalCostLayout
                spacing: 11
                Layout.alignment: Qt.AlignLeft

                Text {
                    text: qsTr("Total: ")
                    color: "#757575"
                    font {
                        family: "Liberation Sans"
                        pointSize: 12
                    }
                }

                Text {
                    text: qsTr("$ %1").arg(price)
                    color: "#757575"
                    font {
                        bold: true
                        family: "Liberation Sans"
                        pointSize: 14
                    }
                }

                Text {
                    text: qsTr("Scan with wallet")
                    color: "#757575"
                    font {
                        family: "Liberation Sans"
                        pointSize: 12
                    }
                }
            }

            Image {
                Layout.alignment: Qt.AlignRight
                Layout.preferredHeight: totalCostLayout.height
                Layout.preferredWidth: totalCostLayout.height
                source: GraftClient.qrCodeImage()
            }
        }

        Rectangle {
            color: "#d7d7d7"
            Layout.preferredHeight: 1.6
            Layout.alignment: Qt.AlignBottom
            Layout.fillWidth: true
        }

        ListModel {
            id: productModel

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

        ListView {
            id: productView
            clip: true
            model: productModel
            enabled: !confirmationRect.visible
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: 23
            Layout.rightMargin: 23
            Layout.topMargin: 9
            Layout.bottomMargin: 9
            delegate: SelectedProductDelegate {
                width: productView.width
                productName: name
                price: cost
            }

            Timer {
                interval: 1000
                running: true
                onTriggered: {
                    parent.state = "twirlState"
                    delay.start()
                }
            }

            Timer {
                id: delay
                interval: 4000
                onTriggered: {
                    parent.state = "checkState"
                }
            }

            states: [
                State {
                    name: "twirlState"
                    PropertyChanges {
                        target: cancelButton
                        visible: true
                    }

                    PropertyChanges {
                        target: busyIndictor
                        visible: true
                    }
                },
                State {
                    name: "checkState"
                    PropertyChanges {
                        target: confirmationRect
                        visible: true
                    }

                    PropertyChanges {
                        target: okButton
                        visible: true
                    }

                    PropertyChanges {
                        target: cancelButton
                        visible: false
                    }
                }
            ]

            BusyIndicator {
                id: busyIndictor
                visible: false
                anchors.centerIn: parent
            }

            Rectangle {
                id: confirmationRect
                color: "#99ffffff"
                visible: false
                anchors.fill: parent

                ColumnLayout {
                    spacing: 12
                    anchors.centerIn: parent

                    Image {
                        source: "qrc:/imgs/paid_icon.png"
                        Layout.preferredHeight: 100
                        Layout.preferredWidth: 100
                    }

                    Text {
                        text: qsTr("PAID !")
                        color: "#757575"
                        Layout.alignment: Qt.AlignHCenter
                        font {
                            family: "Liberation Sans"
                            pointSize: 16
                        }
                    }
                }
            }
        }

        WideRoundButton {
            id: cancelButton
            text: qsTr("Cancel")
            visible: false
            onClicked: pushScreen()
        }

        WideRoundButton {
            id: okButton
            text: qsTr("OK")
            visible: false
            onClicked: pushScreen()
        }
    }
}
