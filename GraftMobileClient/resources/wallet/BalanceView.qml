import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import "../"
import "../components"

BaseScreen {
    id: rootItem

    property real amountGraft: 0
    property real amountMoney: 0

    title: qsTr("mnbvc")

    ColumnLayout {

        anchors.fill: parent
        spacing: 30

        Image {
            id: graftWalletLogo
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 50
            Layout.preferredHeight: parent.width / 2
            Layout.preferredWidth: parent.width / 2
            fillMode: Image.PreserveAspectFit
            source: "qrc:/imgs/graft_wallet_logo.png"
        }

        ColumnLayout {
            spacing: 20
            Layout.alignment: Qt.AlignCenter

            Text {
                Layout.alignment: Qt.AlignCenter
                font {
                    pointSize: 15
                    bold: true
                }
                color: "#707070"
                text: qsTr("Balance")
            }

            Text {
                Layout.alignment: Qt.AlignCenter
                font.pointSize: 19
                color: "black"
                text: amountGraft + "g"
            }

            Text {
                Layout.alignment: Qt.AlignCenter
                font {
                    pointSize: 15
                    bold: true
                }
                color: "#707070"
                text: amountMoney + "USD"
            }
        }

        WideRoundButton {
            text: qsTr("Pay")
            onPressed: {
                rootItem.pushScreen()
            }
        }
    }
}
