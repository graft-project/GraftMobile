import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import "../"
import "../components"

BaseScreen {
    property double amountGraft: 1.2
    property int amountMoney: 145

    title: qsTr("Wallet")

    ColumnLayout {
        spacing: 18
        anchors {
            left: parent.left
            leftMargin: 20
            right: parent.right
            rightMargin: 20
            top: parent.top
        }

        Image {
            Layout.alignment: Qt.AlignCenter
            Layout.preferredHeight: parent.width / 2
            Layout.preferredWidth: parent.width / 2
            fillMode: Image.PreserveAspectFit
            source: "qrc:/imgs/graft_pos_logo.png"
        }

        ColumnLayout {
            spacing: 15
            Layout.alignment: Qt.AlignCenter
            Layout.bottomMargin: 20

            Text {
                text: qsTr("Balance:")
                color: "#707070"
                Layout.alignment: Qt.AlignCenter
                font {
                    bold: true
                    family: "Liberation Sans"
                    pointSize: 17
                }
            }

            Text {
                text: amountGraft + " g"
                color: "black"
                Layout.alignment: Qt.AlignCenter
                font {
                    family: "Liberation Sans"
                    pointSize: 22
                }
            }

            Text {
                text: amountMoney + "USD"
                color: "#707070"
                Layout.alignment: Qt.AlignCenter
                font {
                    family: "Liberation Sans"
                    pointSize: 15
                }
            }
        }

        Text {
            text: qsTr("TRANSFER:")
            color: "#707070"
            Layout.alignment: Qt.AlignCenter
            font {
                family: "Liberation Sans"
                pointSize: 13
            }
        }

        ColumnLayout {
            spacing: 0
            Layout.alignment: Qt.AlignCenter

            WideRoundButton {
                text: qsTr("PAYPAL")
                Layout.topMargin: 0
                Layout.bottomMargin: 0
            }

            WideRoundButton {
                text: qsTr("CHASE XXX929")
                Layout.topMargin: 0
                Layout.bottomMargin: 0
            }
        }
    }
}
