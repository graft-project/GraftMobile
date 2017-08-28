import QtQuick 2.9
import QtQuick.Controls 2.2
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
            fill: parent
            leftMargin: 20
            rightMargin: 20
            topMargin: 10
        }

        Image {
            Layout.alignment: Qt.AlignCenter
            Layout.preferredHeight: parent.width / 2
            Layout.preferredWidth: parent.width / 2
            fillMode: Image.PreserveAspectFit
            source: "qrc:/imgs/graft_pos_logo.png"
        }

        ColumnLayout {
            spacing: 20
            Layout.alignment: Qt.AlignCenter
            Layout.bottomMargin: 20

            Text {
                text: qsTr("Balance:")
                color: "#707070"
                Layout.alignment: Qt.AlignCenter
                font {
                    family: "Liberation Sans"
                    pointSize: 20
                }
            }

            RowLayout {
                spacing: 0
                Layout.preferredWidth: parent.width

                Text {
                    text: amountGraft
                    color: "black"
                    Layout.alignment: Qt.AlignCenter
                    font {
                        family: "Liberation Sans"
                        pointSize: 27
                    }
                }

                Image {
                    Layout.preferredHeight: 28
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/imgs/g_icon_black.png"
                }
            }

            Text {
                text: amountMoney + "USD"
                color: "#707070"
                Layout.alignment: Qt.AlignCenter
                font {
                    family: "Liberation Sans"
                    pointSize: 17
                }
            }
        }

        Text {
            text: qsTr("TRANSFER:")
            color: "#707070"
            Layout.alignment: Qt.AlignCenter
            font {
                family: "Liberation Sans"
                pointSize: 15
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
