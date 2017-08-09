import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import "../"

Item {
    property alias currencyModel: graftCBox.model
    property alias mtotalAmount: totalViewItem.totalAmount
    property int balanceInGraft: 0
    property int balanceInUSD: 0

    ColumnLayout {
        id: column
        spacing: 50
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            topMargin: 50
            leftMargin: 30
            rightMargin: 30
        }

        TotalView {
            id: totalViewItem
            Layout.preferredWidth: parent.width
        }
        ColumnLayout {
            spacing: 170

            ColumnLayout {
                Layout.fillWidth: true
                spacing: -5

                ComboBox {
                    id: graftCBox
                    Layout.fillWidth: true
                    Material.background: "transparent"
                }

                Rectangle {
                    height: 2
                    Layout.fillWidth: true
                    color: "#707070"
                }

                RowLayout {
                    Text {
                        Layout.topMargin: 12
                        color: "#707070"
                        text: qsTr("Balance:\t")
                        font{
                            pointSize: 12
                            family: "Liberation Sans"
                        }
                    }
                    Text {
                        Layout.topMargin: 12
                        color: "#707070"
                        text: qsTr(balanceInGraft + "g / " + balanceInUSD + "USD")
                        font{
                            pointSize: 12
                            family: "Liberation Sans"
                            bold: true
                        }
                    }
                }
            }
            RoundButton {
                id: confirmButton
                highlighted: true
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
                    pointSize: 18
                    capitalization: Font.MixedCase
                }
            }
        }


    }
}
