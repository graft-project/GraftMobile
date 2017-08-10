import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import "../"

Item {
    property alias totalAmount: totalViewItem.totalAmount

    ListModel {
        id: productModel

        ListElement {
            name: "Hairout 1"
            cost: 25
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
                model: productModel
                clip: true
                delegate: SelectedProductDelegate {
                    width: productList.width
                    productName: name
                    price: cost
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
                    Layout.fillWidth: true
                    currencyModel: ["Graft"]
                    balanceInGraft: 1
                    balanceInUSD: 200
                }

                RoundButton {
                    id: confirmButton
                    highlighted: true
                    topPadding: 15
                    bottomPadding: 15
                    Material.elevation: 0
                    Material.accent: "#707070"
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignCenter
                    Layout.leftMargin: 20
                    Layout.rightMargin: 20
                    radius: 15
                    text: qsTr("Confirm")
                    font {
                        family: "Liberation Sans"
                        pointSize: 12
                        capitalization: Font.MixedCase
                    }
                }
            }

            Rectangle {
                color: "transparent"
                BusyIndicator {
                    anchors.centerIn: parent
                    running: image.status === Image.Loading
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
}
